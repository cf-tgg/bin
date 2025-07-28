#!/bin/sh

mkdir bugswriter
cd bugswriter || exit;

for url in  https://youtube.com/watch?v=9ER1cTZ5Gxk \
            https://youtube.com/watch?v=0aV1OoHRP2Y \
            https://youtube.com/watch?v=0MlEBV-UhRE \
            https://youtube.com/watch?v=SRqVuAUP2N0 \
            https://youtube.com/watch?v=ugWydr_QdIY \
            https://youtube.com/watch?v=J4on3rNu3T4 \
            https://youtube.com/watch?v=AdP1CJn4GmA \
            https://youtube.com/watch?v=xx1xj78OWeE \
            https://youtube.com/watch?v=m7kLtwiGyAk \
            https://youtube.com/watch?v=Qz82KHieDBU \
            https://youtube.com/watch?v=3UMcNm6LcDk \
            https://youtube.com/watch?v=knnjI8Kur48 \
            https://youtube.com/watch?v=lXJNmajk1p4 \
            https://youtube.com/watch?v=8iZT55L4NOc \
            https://youtube.com/watch?v=UVYCGJl2uK8 \
            https://youtube.com/watch?v=3i5DKHCAYlw \
            https://youtube.com/watch?v=XwIlM4wknNU \
            https://youtube.com/watch?v=Uc0FkKdmqGk \
            https://youtube.com/watch?v=CLqH2bym6Yo \
            https://youtube.com/watch?v=R6eCdhWOOog
        do
            yt-dlp -f bestvideo+bestaudio "$url" &
done
