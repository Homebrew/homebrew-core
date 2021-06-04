class YoutubeDl < Formula
  include Language::Python::Virtualenv

  desc "Download YouTube videos from the command-line"
  homepage "https://youtube-dl.org/"
  url "https://files.pythonhosted.org/packages/12/67/a37eb6231ff26b4a4bc7cee2568d44e11ffeddb84a9b0798869a4392f3ce/youtube_dl-2021.5.16.tar.gz"
  sha256 "4e569cb0477428fd96ee6f7e7a6640b7c9416be626ed708ac4b8ada6c5a6ffbe"
  license "Unlicense"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "12b99a4d48b9c811d40d70505d20438fe5921906e28def23f246692dab2a2121"
    sha256 cellar: :any_skip_relocation, big_sur:       "3455ab65399930227b79951b056f56ba66ef7c298d08c12fccede8e376e539bb"
    sha256 cellar: :any_skip_relocation, catalina:      "3455ab65399930227b79951b056f56ba66ef7c298d08c12fccede8e376e539bb"
    sha256 cellar: :any_skip_relocation, mojave:        "3455ab65399930227b79951b056f56ba66ef7c298d08c12fccede8e376e539bb"
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
