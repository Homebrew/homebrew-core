class Uberftp < Formula
  desc "Interactive GridFTP client"
  homepage "https://github.com/JasonAlt/UberFTP"
  url "https://github.com/JasonAlt/UberFTP/archive/Version_2_8.tar.gz"
  sha256 "8a397d6ef02bb714bb0cbdb259819fc2311f5d36231783cd520d606c97759c2a"

  bottle do
    cellar :any
    sha256 "5ebc91f1f638e2d3e8287483f3f992b71abcc359b0ba77e87433eb973a6a8a83" => :catalina
    sha256 "4f4fe88e7dbc9c06bf2057f8eae9833709c1880542818dcb2a2666b1eb9764b6" => :mojave
    sha256 "03fc04e9897a29b806bb0f5b527e37f2263bbb2ec7df7b12b6e222c55e7fab41" => :high_sierra
    sha256 "74ab71c89b96942aa3287080033c7b11cb28d1eb1fa37b628b69997976fed892" => :sierra
    sha256 "e8dce3fad5462c096d9e1c4e605280679f9a79b6b9204401fb10d3449807d2d9" => :el_capitan
    sha256 "84ab25a3cae1ac0d4aeb2b967b151b396301eb1f7877bb6225ed202847a35cff" => :yosemite
    sha256 "9c7f1cbb83c268b00a137e608497bafe066ac41a034c256ca55075d1eeb72cfe" => :mavericks
  end

  depends_on "globus-toolkit"

  def install
    globus = Formula["globus-toolkit"].opt_prefix

    # patch needed since location changed with globus-toolkit versions>=6.0,
    # patch to upstream is not yet merged
    # (located at https://github.com/JasonAlt/UberFTP/pull/8)
    # but solves not whole problem (needs aditional patch)
    inreplace "configure", "globus_location/include/globus/gcc64dbg", "globus_location/libexec/include"
    inreplace "configure", "globus_location/lib64", "globus_location/libexec/lib"

    system "./configure", "--prefix=#{prefix}",
                          "--with-globus=#{globus}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/uberftp", "-v"
  end
end
