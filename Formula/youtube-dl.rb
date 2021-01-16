class YoutubeDl < Formula
  include Language::Python::Virtualenv

  desc "Download YouTube videos from the command-line"
  homepage "https://youtube-dl.org/"
  url "https://files.pythonhosted.org/packages/3a/20/9e710f4b791157a0ce55b032a8f61fc357b0c47d237028095565de030879/youtube_dl-2021.1.16.tar.gz"
  sha256 "acf74701a31b6c3d06f9d4245a46ba8fb6c378931681177412043c6e8276fee7"
  license "Unlicense"

  bottle do
    cellar :any_skip_relocation
    sha256 "71cfc3dd72360d9f1dabc947df11ad92ce9ac4f11d989203ca7dcaf48b2e6905" => :big_sur
    sha256 "5830a74e0fad078e68c5866deea607846bd70b1e7c47d430a19eeaf625e97170" => :arm64_big_sur
    sha256 "32cde0c3e4e40469eae6005df8e3f65fe0aa44aa69a65bb20e422d479571f560" => :catalina
    sha256 "be97c9636cc7faeaf814ec4332bd09c53d7833e2fdd912037542e5c99f32b37c" => :mojave
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
