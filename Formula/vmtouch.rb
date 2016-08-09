class Vmtouch < Formula
  desc "Portable file system cache diagnostics and control"
  homepage "https://hoytech.com/vmtouch/"
  url "https://github.com/hoytech/vmtouch/archive/v1.1.0.tar.gz"
  sha256 "1ba2a12aabed977894ce3a272b2fa8ed6ddfec7a720d7686e074f9e756104796"
  head "https://github.com/hoytech/vmtouch.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "74991a9f3757f098c7b5862cdae1c0b6c4b0285e633747aaca9c05a22c43d993" => :el_capitan
    sha256 "f49f5774c4fb73abcddd32ef282e083fd4902b408fb1c39b4c317231dad2d015" => :yosemite
    sha256 "747326a692d1d48b1eb4fecc666df674b625954e85180620ad3d723c438543a2" => :mavericks
  end

  def install
    system "make", "install", "PREFIX=#{prefix}", "MANDIR=#{man}"
  end

  test do
    system bin/"vmtouch", bin/"vmtouch"
  end
end
