class Stm8flash < Formula
  desc "Program your stm8 devices with SWIM/stlinkv(1,2)"
  homepage "https://github.com/vdudouyt/stm8flash"
  url "https://github.com/vdudouyt/stm8flash.git", :revision => "6007cb7062bb86d4c17c79174ee177e80939f602"
  version "20170616-1.1"
  depends_on "libusb"
  depends_on "pkg-config" => :build
  def install
    system "make"
    mkdir_p bin
    cp buildpath/"stm8flash", bin
  end
  test do
    system "#{bin}/stm8flash", "-V"
  end
end
