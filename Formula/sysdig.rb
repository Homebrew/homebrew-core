class Sysdig < Formula
  desc "System-level exploration and troubleshooting tool"
  homepage "http://www.sysdig.org/"
  url "https://github.com/draios/sysdig/archive/0.16.0.tar.gz"
  sha256 "73a0190c973e4a591013d0c73ff2ea9f623ab50b78ff78f7a33fe31460ba24a1"

  bottle do
    sha256 "5e670ac53b704cf9eeff89182b9b7b3a8bf2042bdbc325d4467b31b37cf0b8d3" => :sierra
    sha256 "5e2b31c31768e3bbd9505d68841a51d352a41b8a0165c7b0a54df401fb23aba5" => :el_capitan
    sha256 "04e7cb2f67571daa8608c1ef6bda7b5f203b2be58f537c28a1a55bef25482c2f" => :yosemite
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
