class Vmtouch < Formula
  desc "Portable file system cache diagnostics and control"
  homepage "https://hoytech.com/vmtouch/"
  url "https://github.com/hoytech/vmtouch/archive/v1.1.0.tar.gz"
  sha256 "1ba2a12aabed977894ce3a272b2fa8ed6ddfec7a720d7686e074f9e756104796"
  head "https://github.com/hoytech/vmtouch.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2bb68ec68e92c117cec3b59be96a5a543ff3699b6bbdfdc6b7590f2239bfe2ee" => :sierra
    sha256 "0984801787ebb646b91afc30bf10de9b1e04e6e7d55cfd32540472dda82477d1" => :el_capitan
    sha256 "63ea198ce8bc64061a850437ccd453e5be840a66ddd3ffe9eb183d6dbce02910" => :yosemite
    sha256 "48edbb4ff5867ce1b488bb934a2bd4b00f8f7e2fb13ad5803b8ad0163f61ffd7" => :mavericks
  end

  def install
    system "make", "install", "PREFIX=#{prefix}", "MANDIR=#{man}"
  end

  test do
    system bin/"vmtouch", bin/"vmtouch"
  end
end
