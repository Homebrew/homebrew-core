class RustypasteCli < Formula
  desc "CLI tool for rustypaste"
  homepage "https://blog.orhun.dev/blazingly-fast-file-sharing"
  url "https://github.com/orhun/rustypaste-cli/archive/refs/tags/v0.9.4.tar.gz"
  sha256 "d12b8acb028a92fc6d16347ce3c4b3fa89c86cb902a4a291c116077cc41b1e92"
  license "MIT"
  head "https://github.com/orhun/rustypaste-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4dd88e00b24e6d306c44f10f0b7934b84e083e87dbf394e9cdfde51613e79153"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fd70d2c16dd58461cf1d50ea26fe2f7e6cd0d3d2a6cdde9fb288a06db3f4ed5e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3fb9ddf804c949046ea26ddd3aa294f6e6bfe31d704e4f61aa479f6a715adfb6"
    sha256 cellar: :any_skip_relocation, sonoma:        "b3d4c7cf0192536dc44b459779e281397c3c9f1b9c99bd32183d7922931918b6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b4823974b668f741fd3d8daa19775536c224a34d8581c33d7709711aac52fc8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "662b6202603b7a6330e922a227d676f7d33775355ce392d1eb6f2cd939d8466c"
  end

  depends_on "rust" => :build
  depends_on "rustypaste" => :test

  def install
    system "cargo", "install", *std_cargo_args
    pkgshare.install "config.toml"
  end

  def caveats
    <<~EOS
      An example config is installed to #{opt_pkgshare}/config.toml
    EOS
  end

  test do
    # Upload error: `invalid file size (status code: 400)`
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    rustypaste = Formula["rustypaste"]
    cp rustypaste.opt_pkgshare/"config.toml", testpath/"config.toml"
    port = free_port
    address = "127.0.0.1:#{port}"
    inreplace testpath/"config.toml",
              'address = "127.0.0.1:8000"',
              %Q(address = "#{address}")

    (testpath/".config/rustypaste/config.toml").write <<~EOS
      [server]
      address = "http://#{address}"

      [paste]
      oneshot = false
    EOS

    begin
      server = spawn rustypaste.opt_bin/"rustypaste"
      sleep 1

      file = "awesome.txt"
      text = "some text"
      (testpath/file).write text
      url = shell_output("#{bin}/rpaste #{file}").chomp
      assert_equal text, shell_output("curl #{url}")

      text = "Hello World"
      url = pipe_output("#{bin}/rpaste -", text).chomp
      assert_equal text, shell_output("curl #{url}")
    ensure
      Process.kill "TERM", server
      Process.wait server
    end
  end
end
