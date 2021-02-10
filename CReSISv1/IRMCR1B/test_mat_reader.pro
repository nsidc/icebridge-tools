; Example batch script for mat_reader.pro
;
; Modify the "fn" variable below to point to your CSARP_qlook echogram
; @test_mat_reader

; ========================================================
; Setup and compile
.reset_session
.compile mat_reader.pro

; ========================================================
; Load data
fn = '/cresis/web/cresis_data/datafiles_ftp/snow/2011_Greenland_P3/CSARP_qlook/20110325_05/Data_20110325_05_018.mat'

result = mat_reader(fn,'Data',data)
result = mat_reader(fn,'minData',minData)
result = mat_reader(fn,'maxData',maxData)
result = mat_reader(fn,'GPS_time',gps_time)
result = mat_reader(fn,'Latitude',lat)
result = mat_reader(fn,'Longitude',lon)
result = mat_reader(fn,'Elevation',elev)

; Rescale data to linear power
data = 10^((float(data)*float(maxData[0])/255 + float(minData[0]))/10)

; ========================================================
; Plot Data
size_data = size(data)
device,decomposed=0
window,0,retain=2,xsize=size_data[2],ysize=size_data[1]
wset,0
color_table = 255-[[indgen(255)],[indgen(255)],[indgen(255)]]
tvlct,color_table
tvscl,transpose(10*alog10(data)),/order

; ========================================================
; Plot geographic information
window,1,retain=2,xsize=500,ysize=500
wset,1
tvlct,255-color_table
plot,lon,lat,xrange=[min(lon),max(lon)],yrange=[min(lat),max(lat)],xtitle='Longitude (deg)',ytitle='Latitude (deg)'

window,2,retain=2,xsize=500,ysize=300
wset,2
plot,elev,yrange=[min(elev),max(elev)],xtitle='Index',ytitle='Elevation (m)'

window,3,retain=2,xsize=500,ysize=300
wset,3
plot,gps_time,yrange=[min(gps_time),max(gps_time)],xtitle='Index',ytitle='GPS Time (sec)',title='Seconds since Jan 1, 1970 00:00:00'

