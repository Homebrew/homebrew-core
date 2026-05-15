class ScalaCli < Formula
  desc "Scala language runner and build tool"
  homepage "https://scala-cli.virtuslab.org/"
  url "https://github.com/VirtusLab/scala-cli.git",
      tag:      "v1.13.0",
      revision: "ed37d805bf4a96acb2084747f4905cea95d2d0e1"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_tahoe:   "52ed6ab02c010767cbe0a971c4286267976296cef0c4cb3a0864d68daf4d9776"
    sha256                               arm64_sequoia: "c2d0cb04094bdcf17e1bc1dad1cc188b2c3a136b33090c9d72c13e9b8157a127"
    sha256                               arm64_sonoma:  "fd37db4929cfbde24b672e19f75b3faa87c7b2b2518c8eedb8a76d64976f4f80"
    sha256 cellar: :any_skip_relocation, sonoma:        "2c4a1a12fba82bf11b68c85da7134f59c7cabd0e0e8002e8e9bd87f3010b5e75"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "74710deac0a9ee4c15eec9802b11dfc8f3c18d16f38f019656475b8c0e692ac9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8fe72e808caf09315d3dec22c8e534023ce221d53f0578b352e0cd7a72aed213"
  end

  depends_on "openjdk@17" => [:build, :test]

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    ENV["JAVA_HOME"] = Formula["openjdk@17"].opt_prefix
    ENV["USE_NATIVE_IMAGE_JAVA_PLATFORM_MODULE_SYSTEM"] = "false"
    ENV["COURSIER_CACHE"] = "#{HOMEBREW_CACHE}/coursier/v1"
    ENV["COURSIER_ARCHIVE_CACHE"] = "#{HOMEBREW_CACHE}/coursier/arc"
    ENV["COURSIER_JVM_CACHE"] = "#{HOMEBREW_CACHE}/coursier/jvm"

    system "./mill", "-i", "cli[].base-image.writeDefaultNativeImageScript",
           "--scriptDest", "generate-native-image.sh"

    # Without removing shims, native-image fails with:
    #   Error: Unable to detect supported DARWIN native software development toolchain.
    #   Querying with command '.../shims/mac/super/cc -v' prints:
    #   cc: The build tool has reset ENV; --env=std required.
    # The native-image binary does not propagate HOMEBREW_RUBY_PATH to child
    # processes, so the superenv cc shim aborts. Remove shims so it uses the real C compiler.
    ENV.remove "PATH", Superenv.shims_path
    if OS.linux?
      # native-image doesn't propagate env vars to the gcc subprocess it spawns,
      # so LIBRARY_PATH won't reach the linker. Inject the path directly via
      # -H:CLibraryPath so native-image passes -L to the linker command.
      zlib_lib = Formula["zlib-ng-compat"].opt_lib
      extra = "'-H:CLibraryPath=#{zlib_lib}' '-H:NativeLinkerOption=-Wl,-rpath,#{zlib_lib}'"
      inreplace "generate-native-image.sh", "'--no-fallback'", "'--no-fallback' #{extra}"
    end
    system "bash", "./generate-native-image.sh"

    bin.install Dir["out/cli/*/base-image/nativeImage.dest/scala-cli"].first
  end

  test do
    ENV["SCALA_CLI_HOME"] = testpath
    ENV["COURSIER_CACHE"] = ENV["COURSIER_ARCHIVE_CACHE"] = testpath/".coursier_cache"
    ENV["COURSIER_JVM_CACHE"] = testpath/".coursier_jvm_cache"
    ENV["JAVA_HOME"] = Formula["openjdk@17"].opt_prefix

    (testpath/"Hello.scala").write <<~SCALA
      @main def hello() = println("Hello from Scala CLI")
    SCALA
    assert_match "Hello from Scala CLI", shell_output("#{bin}/scala-cli run --server=false Hello.scala")
    assert_match version.to_s, shell_output("#{bin}/scala-cli version")
  end
end
