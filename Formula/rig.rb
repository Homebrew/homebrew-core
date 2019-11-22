class Rig < Formula
  desc "Provides fake name and address data"
  homepage "https://rig.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/rig/rig/1.11/rig-1.11.tar.gz"
  sha256 "00bfc970d5c038c1e68bc356c6aa6f9a12995914b7d4fda69897622cb5b77ab8"

  bottle do
    cellar :any_skip_relocation
    sha256 "e75fa428f9833207c6fa53e005e32c8d3af48206e08ded637d9633c2af1e0643" => :catalina
    sha256 "8f311170956140550544c6a9e9b31068b61c5db52fefa2c92dd0ad565c0fc145" => :mojave
    sha256 "770e85dcfaeec7cf4e4799572b102bf436afc9f3d28eb828ef838b5a1e1a8152" => :high_sierra
    sha256 "fcc18ba335af01c00a5a7e7e41f6431192393d13eb374513ebe9b0b2a75ab0a0" => :sierra
    sha256 "d82301a0557554e57252ea0d020f32e1d13485077c54f4d68cce01ee9d1b34a3" => :el_capitan
    sha256 "785921276b725db4d309ed0833c7f9fece46b6c73d33caa8e74fec614d8afa68" => :yosemite
    sha256 "5d728db39baacad5daac24db21d3711d3d9558b752f7f4c265d0dfd1acaa3a53" => :mavericks
  end

  def install
    system "make"
    bin.install "rig"
    pkgshare.install Dir["data/*"]
  end

  test do
    system "#{bin}/rig"
  end
end
