class ZvecGrep < Formula
  desc "Agent-friendly hybrid workspace search across code and non-code content"
  homepage "https://github.com/zvec-ai/zvec-grep"
  url "https://registry.npmjs.org/@zvec/zvec-grep/-/zvec-grep-0.2.2.tgz"
  sha256 "a958bb24f161c6d092fe555ddeeb44989f933354d9e21392d89af4bc75bd4393"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "fdf5450fd7e02f90312c70f6740e23c81cc04a1647391c9b137f7bb99300c80f"
    sha256 cellar: :any, arm64_tahoe:       "5bd5d4d2eb01c37f6fe3a44ed2e0526d98da280e746f29cd4f7000edd9bf93b4"
    sha256 cellar: :any, arm64_sequoia:     "4a6f39a575e979f40b9735e0fcceaef3fc0fe9cfa454db38895e4620616558d4"
    sha256 cellar: :any, arm64_linux:       "951d0c0a421e09a377148b84b99a07345aca65a04066d9a57a7afda0fde06688"
    sha256 cellar: :any, x86_64_linux:      "3c2b066dd8b1ede506f3477b1a9ee9b2a800ecfe27967ac021c5d814c2756b2a"
  end

  depends_on "pkgconf" => :build
  depends_on "glib"
  depends_on "node"
  depends_on "ripgrep"
  depends_on "vips"

  on_macos do
    depends_on "gettext"
  end

  resource "node-gyp" do
    url "https://registry.npmjs.org/node-gyp/-/node-gyp-13.1.0.tgz"
    sha256 "15663ca4944844139023390f057e86f1897d855959ea7e96f151d4873be8c71f"

    livecheck do
      url :url
    end
  end

  allow_network_access! :build

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/@zvec/zvec-grep/node_modules"

    # Use `rg` from PATH: zg falls back to it when `@vscode/ripgrep` is absent
    rm_r node_modules.glob("@vscode/ripgrep*")

    # Rebuild `sharp` against our `vips` instead of its pre-built libvips
    rm_r node_modules.glob("@img/sharp-*")
    resource("node-gyp").stage do
      system "npm", "install", *std_npm_args(prefix: buildpath/"node-gyp")
      ENV.append_path "NODE_PATH", buildpath/"node-gyp/lib/node_modules"
    end
    cd node_modules/"sharp" do
      ENV["SHARP_FORCE_GLOBAL_LIBVIPS"] = "1"
      system "npm", "run", "build"
      rm_r "src/build/Release/obj.target"
    end

    # Remove pre-built binaries for other platforms
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : "arm64"
    node_modules.glob("onnxruntime-node/bin/napi-v3/*").each { |dir| rm_r dir if dir.basename.to_s != os }
    node_modules.glob("onnxruntime-node/bin/napi-v3/*/*").each { |dir| rm_r dir if dir.basename.to_s != arch }
    llama_target = OS.mac? ? "mac-#{arch}" : "linux-#{arch}"
    llama_target += "-metal" if OS.mac? && Hardware::CPU.arm?
    node_modules.glob("@node-llama-cpp/*").each { |dir| rm_r dir if dir.basename.to_s != llama_target }
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zg --version")

    (testpath/"f.txt").write("hello unified search\n")
    assert_match "hello", shell_output("#{bin}/zg query --rg hello #{testpath} 2>&1")
  end
end
