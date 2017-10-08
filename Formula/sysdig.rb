class Sysdig < Formula
  desc "System-level exploration and troubleshooting tool"
  homepage "https://www.sysdig.org/"
  url "https://github.com/draios/sysdig/archive/0.19.1.tar.gz"
  sha256 "480d5d8fd7e7373c08008c30bd8e2c7595d5c45d710bf07bd15a522021b560f6"

  bottle do
    sha256 "2562686c9fbf72e30bd5997f6f8ac1185f775db3fd848ce1df58dedb1b163787" => :high_sierra
    sha256 "de446ec074d4803b9a35585ca67ab43d588155ad3697f704279c2364c1891b35" => :sierra
    sha256 "7d81bf6b318e79cd620c644d0eaaf150f8c8ac5eb8120ea7df4d2a671f8d2838" => :el_capitan
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
