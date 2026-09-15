class ScalaCli < Formula
  desc "Scala language runner and build tool"
  homepage "https://scala-cli.virtuslab.org/"
  url "https://github.com/VirtusLab/scala-cli.git",
      tag:      "v1.17.0",
      revision: "3c948617f4c1e324fc2aa2773ea9292f2b99799c"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_golden_gate: "1216707bf83e91ba481689dd5c7ad1cdd73c986358717f908c2b518a082d8746"
    sha256                               arm64_tahoe:       "95fed133a6b1b9721caafba5235d87d01c1e425a881844f739e93be06ce5f380"
    sha256                               arm64_sequoia:     "89d2224875656480357703d89b3c48183757ef00aa8a99a884989711325d0fd7"
    sha256                               arm64_sonoma:      "7c3ff556abdff5f63d0f841c9aaf76eb13beaf64c2ca2aa270d478416fb81423"
    sha256 cellar: :any_skip_relocation, sonoma:            "1dca3c486960014355c0c2df0307f73148a95896b90208724f8418abcaa8785a"
    sha256 cellar: :any,                 arm64_linux:       "04de1cfebd18855a412af33046db5c14e5b53e83a62488e3d1cb0ea8d9b5b768"
    sha256 cellar: :any,                 x86_64_linux:      "59528db52a908fae9d23263a9c85b6966c88ae33ef5020a4e3611ddaafef3594"
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
    # native-image analysis of scala-cli can stay silent for >10 min on
    # CI (GC / resource scan). GraalVM's deadlock watchdog then kills
    # the builder with exit 30 even though the main thread is still running.
    extra = ["-H:DeadlockWatchdogInterval=60", "-H:-DeadlockWatchdogExitOnTimeout"]
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
