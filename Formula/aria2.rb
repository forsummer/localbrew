class Aria2 < Formula
  desc "Download with resuming and segmented downloading"
  homepage "https://aria2.github.io/"
  url "https://github.com/aria2/aria2/releases/download/release-1.37.0/aria2-1.37.0.tar.xz"
  sha256 "60a420ad7085eb616cb6e2bdf0a7206d68ff3d37fb5a956dc44242eb2f79b66b"
  license "GPL-2.0-or-later"
  revision 2

  bottle do
    root_url "https://github.com/forsummer/localbrew/releases/download/aria2"
    rebuild 1
    sha256 ventura: "2571ea59788ec08401c474481b05dbdf1ff354e7d171c45419e02f4f29d0e4b2"
  end

  depends_on "pkgconf" => :build
  depends_on "forsummer/localbrew/c-ares"
  depends_on "forsummer/localbrew/libssh2"
  depends_on "forsummer/localbrew/openssl@3"
  depends_on "forsummer/localbrew/sqlite"

  uses_from_macos "libxml2"

  on_macos do
    depends_on "forsummer/localbrew/gettext"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    ENV.append "LIBS", "-framework Security" if OS.mac?

    args = %w[
      --disable-silent-rules
      --with-libssh2
      --without-gnutls
      --without-libgmp
      --without-libnettle
      --without-libgcrypt
      --without-appletls
      --with-openssl
    ]

    system "./configure", *args, *std_configure_args
    system "make", "install"

    bash_completion.install "doc/bash_completion/aria2c"
  end

  test do
    system bin/"aria2c", "https://brew.sh/"
    assert_path_exists testpath/"index.html", "Failed to create index.html!"
  end
end
