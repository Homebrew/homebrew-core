class YtDlp < Formula
  include Language::Python::Virtualenv

  desc "Fork of youtube-dl with additional features and fixes"
  homepage "https://discord.gg/H5MNcFW63r"
  url "https://github.com/yt-dlp/yt-dlp/releases/download/2021.08.10/yt-dlp.tar.gz"
  sha256 "15bd1028840e9230f7b89ee928914b119858b9011c7083c6cb0c5a60d525f1e6"
  license "Unlicense"

  depends_on "python@3.9"

  def install
    virtualenv_install_with_resources
  end

  test do
    # commit history of homebrew-core repo
    system "#{bin}/youtube-dl", "--simulate", "https://www.youtube.com/watch?v=pOtd1cbOP7k"
    # homebrew playlist
    system "#{bin}/youtube-dl", "--simulate", "--yes-playlist", "https://www.youtube.com/watch?v=pOtd1cbOP7k&list=PLMsZ739TZDoLj9u_nob8jBKSC-mZb0Nhj"
  end
end
