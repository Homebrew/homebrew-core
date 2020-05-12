class Threesdk < Formula
  desc "Software development kit for JumpscaleX"
  homepage "https://wiki.threefold.io/"
  url "https://github.com/threefoldtech/jumpscaleX_core/archive/v10.5.2.tar.gz"
  sha256 "d2ce77a61a198b2cd53f4acce5fd7e5c36c369fc83a05b9f74314530b4f4a175"

  bottle do
    rebuild 1
    sha256 "ef65c759c5097a36323fa9c77756468649e8d1980a3a4e05695c05e39568967c" => :catalina
    sha256 "28f4090610946a4eb207df102d841de23ced0d06ba31cb79e040d883906dcd4f" => :mojave
    sha256 "91dd0caca9bd3f38c439d5a7b6f68440c4274945615fae035ff0a369264b8a2f" => :high_sierra
    sha256 "4921af80137af9cc3d38fd17c9120da882448a090b0a8a3a19af3199b415bfca" => :sierra
    sha256 "c71db15326ee9196cd98602e38d0b7fb2b818cdd48eede4ee8eb827d809e09ba" => :el_capitan
    sha256 "85cc828a96735bdafcf29eb6291ca91bac846579bcef7308536e0c875d6c81d7" => :yosemite
  end

  depends_on "patchelf" => :install
  depends_on "python" => :install
  depends_on "upx" => :install

  def install
    ENV["PATH"] += ":/usr/local/bin:/home/linuxbrew/.linuxbrew/bin"
    system "cd install; pip3 install -r requirements.txt"
    system "cd install; ./package.sh"
    system "cd install; cp dist/3sdk /usr/local/bin/3sdk;"
  end

  test do
    system "false"
  end
end
