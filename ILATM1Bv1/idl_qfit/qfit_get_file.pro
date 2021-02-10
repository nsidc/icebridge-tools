; qfit_get_file.pro
; IDL routine to read data from Airborne Topographic Mapper
; written by Serdar Manizade/ Wallops Flight Facility
;
;usage:  a=qfit_get_file(data,type,FILE=filename,SWAP_ENDIAN=swap)
;	a= 1 if read was successful, else a=0 is returned
;	OUTPUT: data= array into which file data is read. the type and size are set by the get_file.
;	INPUT : type= 'float' or 'integer'
; KEYWORDS:
;	FILE= optional keyword specifying file to be read.  If absent then the 
;		PICKFILE routine is called to interactively specify the file to be read.
;       SUBSAMP= optional keyword specifying the amount of subsampling.  every Nth point is read.
;       HEADER= returns string array (characters) of header content
;       FULLHEADER=returns byte array of header, including the record-identifying prefixes
;
; Note: header data in the data file is stripped automatically.
; modified 2007-oct-04 to add fullheader,preheader keywords

;****************************************************
FUNCTION qfit_get_file,data,datatyp,FILE=filnam,SUBSAMP=subsamp,header=hdr,fullheader=fhdr,preheader=phdr,SWAP_ENDIAN=swap
 
if NOT Keyword_set(filnam) then begin
  filnam=pickfile(GROUP=b,/READ,PATH=path,FILTER=["*"],TITLE='select data file',/MUST_EXIST)
  if filnam EQ '' then Return, 0
  endif 
print,'filnam::',filnam
;datatyp='integer'
if Keyword_set(subsamp) then subsamp=fix(abs(subsamp)) ELSE subsamp=1


;%%%%%%%%% read the selected data file %%%%%%%%%%%%%%%%%%
openr,lun,filnam,/get_lun,SWAP_ENDIAN=swap
reclen=0L
readu,lun,reclen
point_lun,lun,0
data=lonarr(reclen/4,2)
readu,lun,data
print,data(*,0),data(*,1)
if (data(0,1) EQ -9000008L) then nskip=data(1,1) else nskip=reclen
if nskip eq reclen then phdr=data[*,0] else phdr=data
print,'nskip=',nskip
filinfo=Fstat(lun)
numrecs= (filinfo.size-nskip)/reclen
reclen=reclen/4
print,'number of recs in file & words in each rec:',numrecs,reclen
hdr=''

if (data(0,1) EQ -9000008L) then begin   ; CODE FOR READING AOL DATA HEADERS
  data=bytarr((reclen)*4,nskip/(4*reclen)-2)
  readu,lun,data
  fhdr=data
  print,"vvvvvvvvvvvvvv START OF HEADER vvvvvvvvvvvvvvvvvvvv"
  hdr=string(data(4:*,*))
	print,hdr
  print,"^^^^^^^^^^^^^^^ END OF HEADER ^^^^^^^^^^^^^^^^^^^^^"
 ENDIF

IF numrecs EQ 0 then begin
 data=[0]
 return,0
 ENDIF

IF subsamp EQ 1 then begin
    IF (DATATYP EQ 'integer') THEN  begin
       a=assoc(lun,lonarr(reclen,numrecs),nskip) & print,'opening integer file'
     ENDIF ELSE begin
       a=assoc(lun,fltarr(reclen,numrecs),nskip) & print,'opening float file'
     ENDELSE
    data=a(0)
  ENDIF ELSE BEGIN
    IF (DATATYP EQ 'integer') THEN  begin
			 data=lonarr(reclen,numrecs/subsamp)
       a=assoc(lun,lonarr(reclen,1)) & print,'opening integer file'
     ENDIF ELSE begin
			 data=fltarr(reclen,numrecs/subsamp)
       a=assoc(lun,fltarr(reclen,1)) & print,'opening float file'
     ENDELSE
		 recskip=nskip/reclen/4
		help,recskip,numrecs,subsamp,reclen,nskip
		for i=0L,(numrecs-1L)/subsamp-1L do data(*,i)=a(recskip+i*subsamp)
   ENDELSE
free_lun,lun
help,data
print,data(*,0)

Return, 1
 
end ; get_file
 
;****************************************************

