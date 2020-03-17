#!/usr/bin/env python3
# See https://docs.python.org/3.2/library/socket.html
# for a decscription of python socket and its parameters
import socket

import os
import stat
import sys
import urllib.parse
import datetime

from threading import Thread
from argparse import ArgumentParser

BUFSIZE = 4096
CRLF = '\r\n'
METHOD_NOT_ALLOWED = 'HTTP/1.1 405 METHOD NOT ALLOWED{}Allow: GET, HEAD, POST {}Connection: close{}{}'.format(CRLF, CRLF, CRLF, CRLF)
OK = 'HTTP/1.1 200 OK{}{}{}'.format(CRLF, CRLF, CRLF, CRLF)
NOT_FOUND = 'HTTP/1.1 404 NOT FOUND{}Connection: close{}{}'.format(CRLF, CRLF, CRLF, CRLF)
FORBIDDEN = 'HTTP/1.1 403 FORBIDDEN{}Connection: close{}{}'.format(CRLF, CRLF, CRLF, CRLF)
NOT_ACCEPTABLE = 'HTTP/1.1 406 NOT_ACCEPTABLE{}Connection: close{}{}'.format(CRLF, CRLF, CRLF, CRLF)
MOVED_PERMANENTLY = 'HTTP/1.1 301 MOVED PERMANENTLY{}Location: https://www.cs.umn.edu/{}Connection:close{}{}'.format(CRLF, CRLF, CRLF, CRLF)

def get_contents(fname, filetype):
    if (filetype == 'image/jpg' or filetype == 'audio/mp3' or filetype == 'image/png'):
        with open(fname, 'rb') as f:
            return f.read()
    else:
        with open(fname, 'r') as f:
            return f.read()


def check_perms(resource):
    stmode = os.stat(resource).st_mode
    return (getattr(stat, 'S_IROTH') & stmode) > 0


class EchoServer:
  def __init__(self, host, port):
    print('listening on port {}'.format(port))
    self.host = host
    self.port = port

    self.setup_socket()

    self.accept()

    self.sock.shutdown()
    self.sock.close()

  def setup_socket(self):
    self.sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    self.sock.bind((self.host, self.port))
    self.sock.listen(128)

  def accept(self):
    while True:
      (client, address) = self.sock.accept()
      th = Thread(target=self.accept_request, args=(client, address))
      th.start()

  def accept_request(self, client_sock, client_addr):
      data = client_sock.recv(BUFSIZE)
      req = data.decode('utf-8')
      response = self.process_request(req)
      if type(response) == tuple:
          client_sock.send(response[0])
          client_sock.send(response[1])

      else:
          client_sock.send(response)
      client_sock.shutdown(1)
      client_sock.close()
      print('connection closed.')

  def process_request(self, request):
      print(request)
      linelist = request.strip().split(CRLF)
      reqline = linelist[0]
      rlwords = reqline.split() #Method, URL, HTTP]
      acceptList = ''
      for i, val in enumerate(linelist):
          if 'Accept:' in val:
             acceptList =  val
             break
      if len(rlwords) == 0:
          return ''
      if rlwords[0] == 'HEAD':
          resource = rlwords[1][1:] #Skip beginning /
          return self.head_request(resource)
      elif rlwords[0] == 'GET':
          resource = rlwords[1][1:] #Skip beginning /
          return self.get_request(resource, acceptList)
      elif rlwords[0] == 'POST':
          return self.post_request(linelist[len(linelist) - 1])
      else: #ad elif for get, post
         ret = bytes(METHOD_NOT_ALLOWED, "utf-8")
         filetype = 'text/html'
         file_contents = get_contents('405.html', filetype).encode()
         val = (ret, file_contents)
         return val

  def head_request(self, resource):
      path = os.path.join('.', resource)
      if not os.path.exists(resource):
          ret = bytes(NOT_FOUND, "utf-8")
          filetype = 'text/html'
          file_contents = get_contents('404.html', filetype).encode()
          val = (ret, file_contents)
          return val
      elif not check_perms(resource):
          ret = bytes(FORBIDDEN, "utf-8")
          filetype = 'text/html'
          file_contents = get_contents('403.html', filetype).encode()
          val = (ret, file_contents)
          return val
      else:
          ret = bytes(OK, "utf-8")
      return ret

  def post_request(self, resource):
       lst = resource.split("=")
       allVals = []
       for i, val in enumerate(lst):
           if "&" in val:
               newstr1 = ""
               newstr2 = ""
               count1 = 3
               count2 = 3
               ampersand = val.split("&")
               for i in range(len(ampersand[0])):
                   if ampersand[0][i] == "%":
                       newstr1 += bytes.fromhex(ampersand[0][i+1: i+3]).decode('utf-8')
                       count1 = 0
                   else:
                       if (count1 < 2):
                           count1 += 1
                       else:
                           newstr1 += ampersand[0][i]
                           count1 +=1
                   i += 3
               for i in range(len(ampersand[1])):
                   if ampersand[0][i] == "%":
                       newstr2 += bytes.fromhex(ampersand[1][i+1: i+3]).decode('utf-8')
                       count2 = 0
                   else:
                       if (count2 < 2):
                           count2 += 1
                       else:
                           newstr2 += ampersand[1][i]
                           count2 +=1
                   i += 3

               allVals.append(newstr1)
               allVals.append(newstr2)


           else:
               newstrA = ""
               count = 3
               for i in range(len(val)):
                   if val[i] == "%":
                       newstrA += bytes.fromhex(val[i+1: i+3]).decode('utf-8')
                       count = 0
                   else:
                       if (count < 2):
                           count += 1
                       else:
                           newstrA += val[i]
                           count +=1

                   i += 3
               allVals.append(newstrA)
       print(allVals)


       response = '<html><head> <title>Form</title><link rel="stylesheet" type="text/css" href="style.css"></head><body><center><h3><h1>Following Form Data Submitted Successfully</h1><table><tr><td>{}</td><td>{}</td></tr><tr><td>{}</td><td>{}</td></tr><tr><td>{}</td><td>{}</td></tr><tr><td>{}</td><td>{}</td></tr><tr><td>{}</td><td>{}</td></tr></table></p></center></body></html>'.format(allVals[0], allVals[1], allVals[2], allVals[3], allVals[4], allVals[5], allVals[6], allVals[7], allVals[8], allVals[9])
       content = response.encode('utf-8')
       ret = 'HTTP/1.0 200 OK\nContent-Type: ' +'text/html' + '\n\n'
       head = ret.encode()
       return (head, content)


  def get_request(self, resource, acceptableTypes):
      path = os.path.join('.', resource)
      if not os.path.exists(resource):
          ret = bytes(NOT_FOUND, "utf-8")
          filetype = 'text/html'
          file_contents = get_contents('404.html', filetype).encode()
          val = (ret, file_contents)
          return val
      elif not check_perms(resource):
          ret = bytes(FORBIDDEN, "utf-8")
          filetype = 'text/html'
          file_contents = get_contents('403.html', filetype).encode()
          val = (ret, file_contents)
          return val
      else:
          if (path.endswith(".jpg")):
            filetype = 'image/jpg'
            fileAccept = 'image/*'
          if (path.endswith(".png")):
             filetype = 'image/png'
             fileAccept = 'image/*'
          elif (path.endswith(".css")):
            filetype = 'text/css'
            fileAccept = 'text/*'
          elif (path.endswith(".mp3")):
            filetype = 'audio/mp3'
            fileAccept = 'audio/*'
          else:
            filetype = 'text/html'
            fileAccept = 'text/*'
          if '*/*' in acceptableTypes or fileAccept in acceptableTypes or filetype in acceptableTypes:
              if(filetype == 'image/jpg' or filetype == 'audio/mp3' or filetype == 'image/png'):#Send image as a binary
                  file_contents = get_contents(path, filetype)
              else:
                  file_contents = get_contents(path, filetype).encode()

              ret = 'HTTP/1.0 200 OK\nContent-Type: ' + str(filetype) + '\n\n'
          else:
              ret = bytes(NOT_ACCEPTABLE, "utf-8")
              filetype = 'text/html'
              file_contents = get_contents('406.html', filetype).encode()
              val = (ret, file_contents)
              return val
          head = ret.encode()
      val = (head, file_contents)
      return val


def parse_args():
  parser = ArgumentParser()
  parser.add_argument('--host', type=str, default='localhost',
                      help='specify a host to operate on (default: localhost)')
  parser.add_argument('-p', '--port', type=int, default=9001,
                      help='specify a port to operate on (default: 9001)')
  args = parser.parse_args()
  return (args.host, args.port)


if __name__ == '__main__':
  (host, port) = parse_args()
  EchoServer(host, port)
