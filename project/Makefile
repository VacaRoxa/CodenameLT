# credit goes to vrld
# source: https://love2d.org/forums/viewtopic.php?f=3&t=3620&start=20#p47895
love=/Applications/love.app/Contents/MacOS/love
zip=zip

builddir=../bin/build/
distdir=../bin/

windir=/mnt/c/Users/thars/Downloads/love-0.10.2-win32
osxapp=/mnt/c/Users/thars/Downloads/love-0.10.2-macosx-x64/love.app/

game=GAMENAME
sources=main.lua src/**/*.lua libs/**/*.lua **/*.lua *.lua
res=img/*.* music/*.* sfx/*.* fonts/*.* map/*.*

.PHONY : run test love clean win

run : test
	$(love) .

dist : love win osx

love : $(builddir)/$(game).love
	cp $(builddir)/$(game).love $(distdir)/$(game).love

osx : $(builddir)/$(game).app
	cd $(builddir); \
		zip -9 -q -r ../$(distdir)/$(game)[osx].zip $(game).app

win : $(builddir)/$(game).exe
	cd $(builddir); \
		cp $(windir)/*.dll .; \
		zip -q ../$(distdir)/$(game)[win].zip $(game).exe *.dll; \
		rm *.dll

$(builddir)/$(game).app : $(builddir)/$(game).love
	cp -a $(osxapp) $(builddir)/$(game).app
	cp $(builddir)/$(game).love $(builddir)/$(game).app/Contents/Resources/

$(builddir)/$(game).exe : $(builddir)/$(game).love
	cat $(windir)/love.exe $(builddir)/$(game).love > $(builddir)/$(game).exe

$(builddir)/$(game).love : $(sources) $(res)
	mkdir -p $(builddir)
	$(zip) $(builddir)/$(game).love $(sources) $(res)

clean :
	rm -rf $(builddir)/* $(distdir)/*
