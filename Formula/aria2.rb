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
    sha256 ventura: "c82a8dd6b7f62a81bbab7217bd90b0be661be38a2b182e4a42fa3c233a3362ce"
  end

  depends_on "pkgconf" => :build
  depends_on "c-ares"
  depends_on "libssh2"
  depends_on "openssl@3"
  depends_on "sqlite"

  uses_from_macos "libxml2"

  on_macos do
    depends_on "gettext"
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
