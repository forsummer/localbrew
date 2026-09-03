class Fd < Formula
  desc "Simple, fast and user-friendly alternative to find"
  homepage "https://github.com/sharkdp/fd"
  url "https://github.com/sharkdp/fd/archive/refs/tags/v10.5.0.tar.gz"
  sha256 "e6d9e90730bf316101691e49d59cc02565278dc3779d33a77423801569484851"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/sharkdp/fd.git", branch: "master"

  bottle do
    root_url "https://github.com/forsummer/localbrew/releases/download/fd"
    rebuild 1
    sha256 cellar: :any_skip_relocation, ventura: "840ac4d558bf68a1410c55eaa8e03b7b687ac45d35db69d02865669733a1b6df"
  end

  depends_on "rust" => :build

  conflicts_with "fdclone", because: "both install `fd` binaries"

  def install
    ENV["JEMALLOC_SYS_WITH_LG_PAGE"] = "16" if Hardware::CPU.arm? && OS.linux?
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"fd", "--gen-completions", shells: [:bash, :fish, :pwsh])
    zsh_completion.install "contrib/completion/_fd"
    man1.install "doc/fd.1"
  end

  test do
    touch "foo_file"
    touch "test_file"
    assert_equal "test_file", shell_output("#{bin}/fd test").chomp
  end
end
