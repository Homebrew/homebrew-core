class Vultr < Formula
  desc "Command-line tool for Vultr"
  homepage "https://jamesclonk.github.io/vultr"
  url "https://github.com/JamesClonk/vultr/archive/v2.0.1.tar.gz"
  sha256 "928f6c3caf8149f836a609ec43a3d031f0206a8cba095e026535c33c390c1157"
  head "https://github.com/JamesClonk/vultr.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "bd7df17a5c5a6e655ceac39c6e78e432b270d65f7bacd8c61c4e296e8e455171" => :mojave
    sha256 "774bd75bdaea3db4479d9db76f9fdf02a3d6a53502f20c58f1d79790c407a7f8" => :high_sierra
    sha256 "f63560fb4b5d0d784804036262822519a5fed6a33822257e7ffe21e5b307a81a" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/JamesClonk").mkpath
    ln_s buildpath, buildpath/"src/github.com/JamesClonk/vultr"
    system "go", "build", "-o", bin/"vultr"
  end

  test do
    system bin/"vultr", "version"
  end
end
