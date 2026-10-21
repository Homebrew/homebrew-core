class ScalaCli < Formula
  desc "Scala language runner and build tool"
  homepage "https://scala-cli.virtuslab.org/"
  url "https://github.com/VirtusLab/scala-cli.git",
      tag:      "v1.18.0",
      revision: "65126b818f5a135ed3d18eb77e8010cbdb0daae9"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256               arm64_golden_gate: "d989e808208d4fe3cf022f666ab7850912e192f49b50086f2af8fdd9c6b08f5a"
    sha256               arm64_tahoe:       "193f069a5563b5fab34c38ba3b2a25211f6a72cf8a9ad02784cea7de2f72b021"
    sha256               arm64_sequoia:     "ee515205dd48abdf0c1ef1d41f3bf5d85267708f17856931fdfcf11493ce9f50"
    sha256 cellar: :any, arm64_linux:       "a521182ffd350da54bf17b2a59845513877330be70e51a9e23a29f3564fab938"
    sha256 cellar: :any, x86_64_linux:      "3d80b5f266a64a5e9f6504e3a2a07323ec5c89ad9f7b6d70ec28ee3ba6c25b56"
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
