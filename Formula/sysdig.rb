class Sysdig < Formula
  desc "System-level exploration and troubleshooting tool"
  homepage "http://www.sysdig.org/"
  url "https://github.com/draios/sysdig/archive/0.10.1.tar.gz"
  sha256 "fa98d6ec98666e5e052ebebc30d6b40d2b0ca79ce22e236bab39a2cda725297f"

  bottle do
    sha256 "d0517c59a053d8eb99ad498afa6ebb9519274c68361001a14a5f9b4dd45754ec" => :el_capitan
    sha256 "33332ea9b03d69e9e5337baf323a3c2a763de3ddc5edbbde4fe6911fd6c9d965" => :yosemite
    sha256 "9527807337aeb588f37f8feed3dcdddf6445dd5c4dbec2fc422ec741e4414ce6" => :mavericks
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
