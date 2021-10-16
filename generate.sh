#!/bin/sh

TMP=$(tar --exclude="*/*" -tvf $1 | awk '{print $6}')

NAME=$(echo $TMP | awk -F '-' '{print $1}')
PKGNAME=$(echo $NAME | awk '{print tolower($1)}')

VER=$(echo $TMP | awk -F '-' '{print $2}')

echo "$NAME v$VER"

cat > PKGBUILD << EOF
_ogname=$NAME
pkgname=$PKGNAME
pkgver=$VER
pkgrel=1
arch=('any')
license=('unknown')
depends=('renpy')
source=('$1')
md5sums=('SKIP')

EOF

cat >> PKGBUILD << "EOF"
package() {
	cd "$_ogname-$pkgver-linux"

	install -dm 755 $pkgdir/usr/share/$pkgname
	cp -dr --no-preserve=ownership game/* $pkgdir/usr/share/$pkgname/
	
	install -dm 755 $pkgdir/usr/bin/

	echo '#!/bin/sh' > $pkgdir/usr/bin/$pkgname
	echo "exec /usr/bin/renpy /usr/share/$pkgname" >> $pkgdir/usr/bin/$pkgname
	chmod +x $pkgdir/usr/bin/$pkgname
}
EOF

	# echo '[[ -n "$XDG_DATA_HOME" ]] || XDG_DATA_HOME=$HOME/.local/share' >> $pkgdir/usr/bin/$pkgname
	# echo "exec /usr/bin/renpy /usr/share/$pkgname" '--savedir $XDG_DATA_HOME/renpy/$_ogname' >> $pkgdir/usr/bin/$pkgname