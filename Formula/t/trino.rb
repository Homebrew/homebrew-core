class Trino < Formula
  include Language::Python::Shebang

  desc "Distributed SQL query engine for big data"
  homepage "https://trino.io"
  url "https://search.maven.org/remotecontent?filepath=io/trino/trino-server/469/trino-server-469.tar.gz", using: :nounzip
  sha256 "111933d897a7312c2b20eef1184203c180a28833add3c84367c2ca4fdb9b0e02"
  license "Apache-2.0"

  livecheck do
    url "https://search.maven.org/remotecontent?filepath=io/trino/trino-server/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)*)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "791be307105c5a6731790e676d8e681ab569a6b29b3e06dfc09074b125dffedc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "791be307105c5a6731790e676d8e681ab569a6b29b3e06dfc09074b125dffedc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "791be307105c5a6731790e676d8e681ab569a6b29b3e06dfc09074b125dffedc"
    sha256 cellar: :any_skip_relocation, sonoma:        "03069aa7ba823097f4cee85c417464964882fdd10750399e47f418ae8ec21c2f"
    sha256 cellar: :any_skip_relocation, ventura:       "03069aa7ba823097f4cee85c417464964882fdd10750399e47f418ae8ec21c2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "490156059e830eab8739db6440ee197050c62a1dd7c26369fe05ee691234ac51"
  end

  depends_on "gnu-tar" => :build
  depends_on "openjdk"

  uses_from_macos "python"

  resource "trino-src" do
    url "https://github.com/trinodb/trino/archive/refs/tags/469.tar.gz", using: :nounzip
    sha256 "17e1413f3a110b8d33724ce47ac52900e03d8ae723e322b1500a2985cd1bc398"

    livecheck do
      formula :parent
    end
  end

  resource "trino-cli" do
    url "https://search.maven.org/remotecontent?filepath=io/trino/trino-cli/469/trino-cli-469-executable.jar"
    sha256 "1df0abceb1369e6034dd43e447ad31b0f12897731066ad06e4328b44871f3cc3"

    livecheck do
      formula :parent
    end
  end

  def install
    odie "trino-src resource needs to be updated" if version != resource("trino-src").version
    odie "trino-cli resource needs to be updated" if version != resource("trino-cli").version

    # Manually extract tarball to avoid losing hardlinks which increases bottle
    # size from MBs to GBs. Remove once Homebrew is able to preserve hardlinks.
    # Ref: https://github.com/Homebrew/brew/pull/13154
    libexec.mkpath
    system "tar", "-C", libexec.to_s, "--strip-components", "1", "-xzf", "trino-server-#{version}.tar.gz"

    # Manually untar, since macOS-bundled tar produces the error:
    #   trino-363/plugin/trino-hive/src/test/resources/<truncated>.snappy.orc.crc: Failed to restore metadata
    # Remove when https://github.com/trinodb/trino/issues/8877 is fixed
    resource("trino-src").stage do |r|
      ENV.prepend_path "PATH", Formula["gnu-tar"].opt_libexec/"gnubin"
      system "tar", "-xzf", "trino-#{r.version}.tar.gz"
      (libexec/"etc").install Dir["trino-#{r.version}/core/docker/default/etc/*"]
      inreplace libexec/"etc/node.properties", "docker", tap.user.downcase
      inreplace libexec/"etc/node.properties", "/data/trino", var/"trino/data"
      inreplace libexec/"etc/jvm.config", %r{^-agentpath:/usr/lib/trino/bin/libjvmkill.so$\n}, ""
    end

    rewrite_shebang detected_python_shebang(use_python_from_path: true), libexec/"bin/launcher.py"
    (bin/"trino-server").write_env_script libexec/"bin/launcher", Language::Java.overridable_java_home_env

    resource("trino-cli").stage do
      libexec.install "trino-cli-#{version}-executable.jar"
      bin.write_jar_script libexec/"trino-cli-#{version}-executable.jar", "trino"
    end

    # Remove incompatible pre-built binaries
    launcher_dirs = libexec.glob("bin/{darwin,linux}-*")
    # Keep the linux-amd64 directory to make bottles identical
    launcher_dirs.reject! { |dir| dir.basename.to_s == "linux-amd64" } if build.bottle?
    launcher_dirs.reject! do |dir|
      dir.basename.to_s == "#{OS.kernel_name.downcase}-#{Hardware::CPU.intel? ? "amd64" : "arm64"}"
    end
    rm_r launcher_dirs
  end

  def post_install
    (var/"trino/data").mkpath
  end

  service do
    run [opt_bin/"trino-server", "run"]
    working_dir opt_libexec
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/trino --version")
    # A more complete test existed before but we removed it because it crashes macOS
    # https://github.com/Homebrew/homebrew-core/pull/153348
    # You can add it back when the following issue is fixed:
    # https://github.com/trinodb/trino/issues/18983#issuecomment-1794206475
    # https://bugs.openjdk.org/browse/CODETOOLS-7903448
  end
end
