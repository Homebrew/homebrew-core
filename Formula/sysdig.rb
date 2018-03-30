class Sysdig < Formula
  desc "System-level exploration and troubleshooting tool"
  homepage "https://www.sysdig.org/"
  url "https://github.com/draios/sysdig/archive/0.21.0.tar.gz"
  sha256 "3ba35ca1e84dd4487bdeff078ff0e48c862fa6887688f9c8d4a076865c6f9a05"

  bottle do
    sha256 "79a27d9234019ebb44a103d6c697c5fe5e47b4790c90bfbac75629f7125577fb" => :high_sierra
    sha256 "2c33f831dcd89e94b1a232484f5eeb79c9fee3f65be1f7323e366d41e7e1a17a" => :sierra
    sha256 "ab93f46d46f24ea996b3967e8158882da094e366d08b4a92f4e060943a1c726a" => :el_capitan
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
