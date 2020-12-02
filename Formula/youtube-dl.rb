class YoutubeDl < Formula
  include Language::Python::Virtualenv

  desc "Download YouTube videos from the command-line"
  homepage "https://youtube-dl.org/"
  url "https://files.pythonhosted.org/packages/fa/3c/f05e5649c81bcc5796ba913a5654a0305bc3a89982727b6fed295baddc2c/youtube_dl-2020.12.2.tar.gz"
  sha256 "bc82acb0b59b25b822fad85bef0cbe78e5754ca532e3bd6899fe06386e2b8e7c"
  license "Unlicense"

  bottle do
    cellar :any_skip_relocation
    sha256 "42f350b8ed9148a37aae4afea76aa9f5a60402bf3a56163916aaf6027d298082" => :big_sur
    sha256 "820ccc4953c90015d69e5c11ef133f5caf37c2115a476f40ded8e4a83d3d3d65" => :catalina
    sha256 "1953cdb1e9bd334e5270d5cf837a9657f1a84991e2f8806285c6019c6590a851" => :mojave
  end

  depends_on "python@3.9"

  def install
    virtualenv_install_with_resources
    man1.install_symlink libexec/"share/man/man1/youtube-dl.1" => "youtube-dl.1"
    bash_completion.install libexec/"etc/bash_completion.d/youtube-dl.bash-completion"
    fish_completion.install libexec/"etc/fish/completions/youtube-dl.fish"
  end

  test do
    # commit history of homebrew-core repo
    system "#{bin}/youtube-dl", "--simulate", "https://www.youtube.com/watch?v=pOtd1cbOP7k"
    # homebrew playlist
    system "#{bin}/youtube-dl", "--simulate", "--yes-playlist", "https://www.youtube.com/watch?v=pOtd1cbOP7k&list=PLMsZ739TZDoLj9u_nob8jBKSC-mZb0Nhj"
  end
end
