class Sysdig < Formula
  desc "System-level exploration and troubleshooting tool"
  homepage "https://www.sysdig.org/"
  url "https://github.com/draios/sysdig/archive/0.23.1.tar.gz"
  sha256 "57d5b713b875eba35546a1408bf3f20c2703904a17d956be115ee55272db4cfa"

  bottle do
    sha256 "109983ecf16ccc70ab077566e87f43b01373a613670195ae0fb18962554b483b" => :high_sierra
    sha256 "5ef340e09ced2647da21e43c48f68904d1414c701eca1f707a7d7e35ec1d1fdd" => :sierra
    sha256 "18272edda58272ce3d14b2039306b7129a0e5c44638dfb347798d202a75ed646" => :el_capitan
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
