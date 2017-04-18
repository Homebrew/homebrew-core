class Sysdig < Formula
  desc "System-level exploration and troubleshooting tool"
  homepage "http://www.sysdig.org/"
  url "https://github.com/draios/sysdig/archive/0.15.1.tar.gz"
  sha256 "4b404e15da9050742e62f3d65e0013fb497f84132ead4da61ba658c4f3d33a74"

  bottle do
    sha256 "f438211622a4dd7cbefde45b17f9a6e11b8521e58fea02f03d05ee93f1f81990" => :sierra
    sha256 "054352584fa2a1a5a5e5058c0201c45de96f0fb6ddbe5987bdace86211f717f9" => :el_capitan
    sha256 "065970b0c8c0ed1755afc4a5007c3a5771bf00a32604a57d0d9d355263b741f6" => :yosemite
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
