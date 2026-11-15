class Sac < Formula
  desc "Seismic Analysis Code, Community Edition"
  homepage "https://github.com/EarthScope/sac-community"
  url "https://github.com/EarthScope/sac-community/archive/refs/tags/v103.0.tar.gz"
  sha256 "f61fbe30d0411fe3033bdb76731062da24940c27920338d0f91a867842b791b8"
  license "Apache-2.0"

  bottle do
    sha256 arm64_golden_gate: "b4effd458af55e1172c9e56e455e5fb5bb3cc2e50100c228a74ce4b1246c7674"
    sha256 arm64_tahoe:       "9e9bbc30fbcb510a79c778d2d997d29d4ace345b4d4c213f0b4eb00c8af0503d"
    sha256 arm64_sequoia:     "bcc90e2b9ecea74aa7e5a916e280b37d862bbf409060f2308e09796f57b17f8d"
    sha256 arm64_linux:       "b8b24aee676362759179551ad36bc1d9064de969aa50098b291479d7c42a9d6e"
    sha256 x86_64_linux:      "f3b04426d21c6672f3ef0b0679517f0cd87e6ec870dfce90798acaf618b35ab1"
  end

  depends_on "pkgconf" => :build
  depends_on "libx11"
  depends_on "libxpm"

  uses_from_macos "curl"
  uses_from_macos "libxml2"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def install
    # configure does not search the Homebrew prefix for X11
    system "./configure", "--x-includes=#{formula_opt_include("libx11")}",
                          "--x-libraries=#{formula_opt_lib("libx11")}",
                          *std_configure_args
    system "make"
    system "make", "install"

    # The environment scripts are sourced, not executed
    pkgshare.install bin/"sacinit.sh", bin/"sacinit.csh"
    rm lib/"README_lib"
  end

  def caveats
    <<~EOS
      Configuration scripts live in: #{opt_pkgshare}
    EOS
  end

  test do
    (testpath/"commands.m").write <<~EOS
      fg impulse npts 100 delta 0.01
      w test.sac
      quit
    EOS

    system bin/"sac", "commands.m"
    assert_equal %w[test.sac 0.01 100], shell_output("#{bin}/saclst delta npts f test.sac").split
  end
end
