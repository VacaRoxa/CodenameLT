# proper Ubuntu 16.04 Makefile by Érico Vieira Porto
# modded on top of vrld makefile
# source: https://love2d.org/forums/viewtopic.php?f=3&t=3620&start=20#p47895
love=/usr/bin/love
zip=/usr/bin/zip
luac=/usr/bin/luac
dosnap=dosnap.sh
dosnap_clean=dosnap_clean.sh

builddir=../bin/build/
distdir=../bin/
snaptemplatedir=../dist/snap-template/

LOVE_WINDIR?=~/Downloads/love-0.10.2-win64
LOVEAPP_OSX?=~/Downloads/love-0.10.2-macosx-x64/love.app


company=VacaRoxa
game=CodenameLT
sources=main.lua src/**/*.lua libs/**/*.lua libs/**/**/*.lua **/*.lua *.lua
res=fonts/*.* img/*.* music/*.* sfx/*.* fonts/*.* map/*.*

.PHONY : run test love clean win

run : test
	$(love) .

test :
	$(luac) -p $(sources)

dist : love win osx

snap : $(builddir)/$(game).love
	cp $(builddir)/$(game).love $(snaptemplatedir)/codenamelt/$(game).love
	cd $(snaptemplatedir)/snap/; \
		./$(dosnap);


love : $(builddir)/$(game).love
	cp $(builddir)/$(game).love $(distdir)/$(game).love

osx : $(builddir)/$(game).app
	cd $(builddir); \
		zip -9 -q -r ../$(distdir)/$(game).osx.zip $(game).app

win : $(builddir)/$(game).exe
	cd $(builddir); \
		cp $(LOVE_WINDIR)/*.dll .; \
		zip -q ../$(distdir)/$(game).win.zip $(game).exe *.dll; \
		rm *.dll

$(builddir)/$(game).app : $(builddir)/$(game).love
	cp -a $(LOVEAPP_OSX) $(builddir)/$(game).app
	cp $(builddir)/$(game).love $(builddir)/$(game).app/Contents/Resources/
	sed -i.bak 's/<string>LÖVE<\/string>/<string>$(game)<\/string>/g' "$(builddir)/$(game).app/Contents/Info.plist"
	sed -i.bak 's/<string>org\.love2d\.love<\/string>/<string>org\.$(company)\.$(game)<\/string>/g' "$(builddir)/$(game).app/Contents/Info.plist"
	sed -i.bak '/<key>UTExportedTypeDeclarations<\/key>/,/^\t<\/array>/{d}' "$(builddir)/$(game).app/Contents/Info.plist"

$(builddir)/$(game).exe : $(builddir)/$(game).love
	cat $(LOVE_WINDIR)/love.exe $(builddir)/$(game).love > $(builddir)/$(game).exe

$(builddir)/$(game).love : $(sources) $(res)
	mkdir -p $(builddir)
	mkdir -p $(distdir)
	$(zip) $(builddir)/$(game).love $(sources) $(res)

clean :
	rm -rf $(builddir)/* $(distdir)/*
	cd $(snaptemplatedir)/snap/; \
		./$(dosnap_clean);
