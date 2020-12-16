class YoutubeDl < Formula
  include Language::Python::Virtualenv

  desc "Download YouTube videos from the command-line"
  homepage "https://youtube-dl.org/"
  url "https://files.pythonhosted.org/packages/a9/0f/a731f1a70b9ef99d677e102a7bba535c566dd7471e4288164461a3b4843a/youtube_dl-2020.12.14.tar.gz"
  sha256 "eaa859f15b6897bec21474b7787dc958118c8088e1f24d4ef1d58eab13188958"
  license "Unlicense"

  bottle do
    cellar :any_skip_relocation
    sha256 "5f2a2e7aa3c19963af8dc2339dab662a19c8d94f2a83450f18cc78e2ee0cb516" => :big_sur
    sha256 "ab8a02e2db35d53df6361de57520aa463b55563fe990f0c59e477d1e4e539ec2" => :catalina
    sha256 "55dc22a1db012a2e89fe4e82e3edfebda0693fc31cd1dc3f7891283bd74e678a" => :mojave
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
