:: Script for copying file from local source to remote FTP server
:: FTP commands is read by file "ftpcmd.ftp", remember to edit file locations.

@echo off
title CopyToFTP

echo Establishing FTP connection and uploading file

@ftp -n -s:ftpcmd.ftp sftp.example.com

echo Complete