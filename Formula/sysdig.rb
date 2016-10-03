class Sysdig < Formula
  desc "System-level exploration and troubleshooting tool"
  homepage "http://www.sysdig.org/"
  url "https://github.com/draios/sysdig/archive/0.11.0.tar.gz"
  sha256 "59ae661c8eb33d00f31d33d48a908261bb4b0e2d001e1f40e16b5855fe46103b"
  revision 1

  bottle do
    sha256 "4191e3d908a14358874d1dc2a017ce510ea4b7865efeab15fd78723b071002ef" => :sierra
    sha256 "640deefef03c2734af21d8a83b19366486a3e4069ae88fdcb3d7694b92d0bc63" => :el_capitan
    sha256 "3e5b72bc47c6ad4f09288da14931f1b410ec8ef193bfd656cbdf01862e95bd2a" => :yosemite
    sha256 "5f36a20b40dc022715a2d9973d59855223ffabf4938395137b58cdeba4f19505" => :mavericks
  end

  depends_on "cmake" => :build
  depends_on "jsoncpp"
  depends_on "luajit"

  # More info on https://gist.github.com/juniorz/9986999
  resource "sample_file" do
    url "https://gist.githubusercontent.com/juniorz/9986999/raw/a3556d7e93fa890a157a33f4233efaf8f5e01a6f/sample.scap"
    sha256 "efe287e651a3deea5e87418d39e0fe1e9dc55c6886af4e952468cd64182ee7ef"
  end

  def install
    ENV.libcxx if MacOS.version < :mavericks

    mkdir "build" do
      system "cmake", "..", "-DSYSDIG_VERSION=#{version}",
                            "-DUSE_BUNDLED_DEPS=OFF",
                            *std_cmake_args
      system "make", "install"
    end

    (pkgshare/"demos").install resource("sample_file").files("sample.scap")
  end

  test do
    output = shell_output("#{bin}/sysdig -r #{pkgshare}/demos/sample.scap")
    assert_match "/tmp/sysdig/sample", output
  end
end
