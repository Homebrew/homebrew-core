class Qfs < Formula
  desc "High-performance, fault-tolerant, distributed file system and its tools"
  homepage "https://github.com/quantcast/qfs"
  url "https://github.com/quantcast/qfs/archive/c7f6950df21780bb02222c311fc797fa37a3b66d.tar.gz"
  version "1.1.4-1"
  sha256 "fbced6b93ef4d74bc1deb66e89f67b3c2f8f6de902276ad1d443881343d9ac20"

  depends_on "boost"
  depends_on "cmake" => :build
  depends_on "maven" => :build
  depends_on "openssl" => :build
  depends_on "wget"

  def install
    ENV.java_cache

    system "make", "build", "hadoop-jars", "BUILD_TYPE=release"
    rm_rf "build/release/bin/examples"
    rm_rf "build/release/bin/tests"

    bin.install Dir["build/release/bin/tools/*"]
    bin.install Dir["build/release/bin/emulator/*"]
    bin.install Dir["build/release/bin/devtools/*"]
    bin.install Dir["build/release/bin/*"]

    libexec.install Dir["build/java/hadoop-qfs/*.jar"]
    libexec.install "build/java/qfs-access/qfs-access-master.jar"

    lib.install Dir["build/release/lib/*.dylib"]
    lib.install Dir["build/release/lib/static/*.a"]

    include.install Dir["build/release/include/kfs/*"]
  end

  test do
    system "#{bin}/qfs", "-ls", "/"
  end
end
