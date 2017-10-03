from picamera.array import PiRGBArray
from picamera import PiCamera
import cv2
import time
from math import ceil

SavePicture = False;
a = 0;
b=0;
c=0;
frameCounter = 0
camera = PiCamera()
camera.resolution = (320, 240)
camera.framerate = 30
rawCapture = PiRGBArray(camera, size=(320, 240))

display_window = cv2.namedWindow("Faces")

face_cascade = cv2.CascadeClassifier('/usr/share/opencv/haarcascades/haarcascade_frontalface_alt.xml')

time.sleep(1)

for frame in camera.capture_continuous(rawCapture, format="bgr", use_video_port=True):

    image = frame.array
    #FACE DETECTION STUFF
    gray = cv2.cvtColor(image,cv2.COLOR_BGR2GRAY)
    c += 1;
    SavePicture = False;
    faces = face_cascade.detectMultiScale(gray, 1.1, 5)
    for (x,y,w,h) in faces:
        cv2.rectangle(image,(x,y),(x+w,y+h),(255,0,0),2)
        if(w>10 and h>10):
            SavePicture = True;
            

    #DISPLAY TO WINDOW
    cv2.imshow("Faces", image)
    NumberOfFrames = 10
    if( c>= (a*NumberOfFrames)):
        if(SavePicture == True):
            FileName = "FaceCap" + str(b) + ".png"
            cv2.imwrite(FileName, image)
            SavePicture = False;
            a=int(ceil(c//NumberOfFrames))+1;
            b+=1;

            
    key = cv2.waitKey(1)

    rawCapture.truncate(0)
    frameCounter = 0
    print "a=" + str(a);
    print "c=" + str(c);

    if key == 27:
        camera.close()
        cv2.destroyAllWindows()
        break
