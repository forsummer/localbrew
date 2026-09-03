class Zoxide < Formula
  desc "Shell extension to navigate your filesystem faster"
  homepage "https://github.com/ajeetdsouza/zoxide"
  url "https://github.com/ajeetdsouza/zoxide/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "4fcd4272b013a10b637dbcc299c58a9924b94470a9042677ca1a204cc2e9150e"
  license "MIT"

  bottle do
    root_url "https://github.com/forsummer/localbrew/releases/download/zoxide"
    rebuild 1
    sha256 cellar: :any_skip_relocation, ventura: "271b0a0f5524233380cb22a1ec91b3e92a15a4f03a9eedc0d6c85622d36225a8"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    bash_completion.install "contrib/completions/zoxide.bash" => "zoxide"
    zsh_completion.install "contrib/completions/_zoxide"
    fish_completion.install "contrib/completions/zoxide.fish"
    share.install "man"
  end

  test do
    assert_empty shell_output("#{bin}/zoxide add /").strip
    assert_equal "/", shell_output("#{bin}/zoxide query").strip
  end
end
