class Ykdl < Formula
  include Language::Python::Virtualenv

  desc "Video downloader that focus on China mainland video sites"
  homepage "https://github.com/zhangn1985/ykdl"
  url "https://github.com/zhangn1985/ykdl/archive/v1.7.0.tar.gz"
  sha256 "44e9d946c0e311a5469319a200af5bc5a6e461efa0f117f6a9608f820f22ecb8"
  license "MIT"

  depends_on "python@3.9"

  def install
    virtualenv_install_with_resources
  end

  def caveats
    "To merge video slides, run `brew install ffmpeg`."
  end

  test do
    system bin/"ykdl", "--info", "https://v.youku.com/v_show/id_XNTAzNDM5NTQ5Mg==.html"
  end
end
