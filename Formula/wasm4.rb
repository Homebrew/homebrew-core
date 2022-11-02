require "language/node"

class Wasm4 < Formula
  desc "Low-level fantasy game console for building small games with WebAssembly"
  homepage "https://wasm4.org/"
  url "https://github.com/aduros/wasm4.git",
      tag:      "v2.5.3",
      revision: "9d782a5c0465e54ec8a4b95d21e4e8a10fdd9ae2"
  license "ISC"

  depends_on "cmake" => :build
  depends_on "node"

  on_linux do
    depends_on "alsa-lib"
    depends_on "libxcursor"
    depends_on "libxext"
    depends_on "libxi"
    depends_on "libxinerama"
    depends_on "libxkbcommon"
    depends_on "libxrandr"
    depends_on "pulseaudio"
  end

  def install
    cd "runtimes/native" do
      system "cmake", "-S", ".", "-B", "build", *std_cmake_args
      system "cmake", "--build", "build"
      if OS.mac?
        (buildpath/"cli/assets/natives").install "build/wasm4" => "wasm4-mac"
      else
        (buildpath/"cli/assets/natives").install "build/wasm4" => "wasm4-linux"
      end
    end
    cd "devtools/web" do
      system "npm", "install", *Language::Node.local_npm_install_args
    end
    cd "runtimes/web" do
      system "npm", "install", *Language::Node.local_npm_install_args
      system "npm", "run", "build"
      rm_f buildpath/"cli/assets/runtime"
      (buildpath/"cli/assets").install "dist" => "runtime"
    end
    cd "cli" do
      system "npm", "install", *Language::Node.std_npm_install_args(libexec)
      bin.install_symlink Dir["#{libexec}/bin/*"]
    end
  end

  test do
    npm = Formula["node"].opt_libexec/"bin/npm"
    system bin/"w4", "new", "--assemblyscript", "hello-world"
    cd "hello-world" do
      system npm, "install"
      system npm, "run", "build"
      system bin/"w4", "bundle", "--html", "hello.html", "build/cart.wasm"
      assert_predicate Pathname.pwd/"hello.html", :exist?
      if OS.mac?
        system bin/"w4", "bundle", "--mac", "hello", "build/cart.wasm"
      else
        system bin/"w4", "bundle", "--linux", "hello", "build/cart.wasm"
      end
      assert_predicate Pathname.pwd/"hello", :exist?
    end
  end
end
