class ScalaCli < Formula
  desc "Scala language runner and build tool"
  homepage "https://scala-cli.virtuslab.org/"
  url "https://github.com/VirtusLab/scala-cli.git",
      tag:      "v1.17.1",
      revision: "c6fb50d0a4983bea16f505dbbffb56df22f321b7"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256               arm64_golden_gate: "261f205fe6d959793887c02c3787ce1df80d670b89393a66da491f09224db342"
    sha256               arm64_tahoe:       "ef59fde0456a450d3290787c419b571903d2fcb13f144c01a5aea04c96d35465"
    sha256               arm64_sequoia:     "9321a2375ae1fa2a657bc1059a0320c9dbf1717f431c9ad834238658235ba29d"
    sha256 cellar: :any, arm64_linux:       "5efa8c9b6569cc39b842c6f70cf92aaff30e9ae1f2f8ced57e8744d1943517a9"
    sha256 cellar: :any, x86_64_linux:      "d6fecc5ccfacab6e0f44b3e130daaf8f03652dbbe9278dcddeecd12c807f94a9"
  end

  depends_on "openjdk@17" => [:build, :test]

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    ENV["JAVA_HOME"] = formula_opt_prefix("openjdk@17")
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
    # The builder needs ~4GB of heap but defaults to ~3GB on macOS CI, where it runs out of memory
    extra = ["-J-Xmx5g"]
    if OS.linux?
      # native-image doesn't propagate env vars to the gcc subprocess it spawns,
      # so LIBRARY_PATH won't reach the linker. Inject the path directly via
      # -H:CLibraryPath so native-image passes -L to the linker command.
      zlib_lib = formula_opt_lib("zlib-ng-compat")
      extra << "-H:CLibraryPath=#{zlib_lib}"
      extra << "-H:NativeLinkerOption=-Wl,-rpath,#{zlib_lib}"
    end
    inreplace "generate-native-image.sh", "'--no-fallback'",
              "'--no-fallback' #{extra.map { |f| "'#{f}'" }.join(" ")}"
    system "bash", "./generate-native-image.sh"

    bin.install Dir["out/cli/*/base-image/nativeImage.dest/scala-cli"].first
  end

  test do
    ENV["SCALA_CLI_HOME"] = testpath
    ENV["COURSIER_CACHE"] = ENV["COURSIER_ARCHIVE_CACHE"] = testpath/".coursier_cache"
    ENV["COURSIER_JVM_CACHE"] = testpath/".coursier_jvm_cache"
    ENV["JAVA_HOME"] = formula_opt_prefix("openjdk@17")

    (testpath/"Hello.scala").write <<~SCALA
      @main def hello() = println("Hello from Scala CLI")
    SCALA
    assert_match "Hello from Scala CLI", shell_output("#{bin}/scala-cli run --server=false Hello.scala")
    assert_match version.to_s, shell_output("#{bin}/scala-cli version")
  end
end
