class ScalaCli < Formula
  desc "Scala language runner and build tool"
  homepage "https://scala-cli.virtuslab.org/"
  url "https://github.com/VirtusLab/scala-cli.git",
      tag:      "v1.12.4",
      revision: "ca3f6e8f59562e1adcf798cd868b0233500f94f1"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_tahoe:   "bbe4de04e1a58fb60cf7f6abd8d9839ebb0a89a48f3f003659a9f553cdae5708"
    sha256                               arm64_sequoia: "92cb26714138cd1eab785157659477e0883fd0ca4e51ff7820cb54332e6b83c5"
    sha256                               arm64_sonoma:  "e3667e5d7edec1eeb3f53d00d0be9ac16821f83d5c23d3b6c6fa9049ba375518"
    sha256 cellar: :any_skip_relocation, sonoma:        "954a05d9404aa9ee9fe9d595995a64aa28e89274ad840414144795ffb825ca01"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d22f74419d8c1558e0844a50d2cb82711d93412faa9f04c393a77bef3bb9549f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eef9116b580721ac705d3b0ccc9a10b78411087163e80b1fa1f22153c107e4de"
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
