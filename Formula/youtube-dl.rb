class YoutubeDl < Formula
  include Language::Python::Virtualenv

  desc "Download YouTube videos from the command-line"
  homepage "https://youtube-dl.org/"
  url "https://files.pythonhosted.org/packages/ac/23/35115dffcaa896b75a3a857fb8949cef870e168447b6452b9f8443750454/youtube_dl-2020.12.22.tar.gz"
  sha256 "fc5368f34e6db3ebeda6071e65eff9490a01722537626f535b7b7b302148b999"
  license "Unlicense"

  bottle do
    cellar :any_skip_relocation
    sha256 "5f2a2e7aa3c19963af8dc2339dab662a19c8d94f2a83450f18cc78e2ee0cb516" => :big_sur
    sha256 "a8a2e02547f44713ebbec734a7311cf4687ff84a5d93744d14f4fdd5360a7154" => :arm64_big_sur
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
