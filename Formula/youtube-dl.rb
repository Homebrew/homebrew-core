class YoutubeDl < Formula
  include Language::Python::Virtualenv

  desc "Download YouTube videos from the command-line"
  homepage "https://youtube-dl.org/"
  url "https://files.pythonhosted.org/packages/be/d5/15995c54364497d2706011439c94a8629ccffc5c2ce0c406929b3958f27a/youtube_dl-2021.3.3.tar.gz"
  sha256 "02432aa2dd0e859e64d74fca2ad624abf3bead3dba811d594100e1cb7897dce7"
  license "Unlicense"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "65f9444c23d097d383608ad528886f02d5c162bb40808445227877f225cd5e5a"
    sha256 cellar: :any_skip_relocation, big_sur:       "326f2a0caa1c1abaa383c33b1b9d1c018089facd706c590f35c594b790501c99"
    sha256 cellar: :any_skip_relocation, catalina:      "872aae1eae8ac261c90307c18f62448e3ad6649577d9dfdb661789be41e28e98"
    sha256 cellar: :any_skip_relocation, mojave:        "3b7f6e505dfe070aae9f537955aa3d8e0f4473a327b9570f4b14a4f2ce39a975"
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
