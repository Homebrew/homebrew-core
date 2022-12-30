class Tauri < Formula
    desc "Command-line interface for building  apps"
    homepage "https://tauri.app"
    url "https://github.com/tauri-apps/tauri/archive/refs/tags/cli.rs-v1.2.2.tar.gz"
    sha256 "3f2d92e4d3bdb200994410832f032f08d7cb46e83728d32fdda50a707e30b810"
    license any_of: ["MIT", "Apache-2.0"]
    head "https://github.com/tauri-apps/tauri.git", branch: "dev"
  
    depends_on "rust" => :build
  
    uses_from_macos "zlib"
  
    on_linux do
      depends_on "pkg-config" => :build
    end
  
    def install
      system "cargo", "install", "--path", "tooling/cli", "--root", prefix
      mv bin/"cargo-tauri", bin/"tauri"
    end
  
    test do
      ohai testpath
      # test that versioning works
      assert_equal "tauri-cli #{version}", shell_output("#{bin}/tauri --version").strip
  
      # test that the help command works
      assert_match "Command line interface for building Tauri apps\n", shell_output("#{bin}/tauri help")
  
      # test that tauri init works
      (testpath/"dist/index.html").write "<!DOCTYPE html><html><head><meta charset=\"utf-8\" /></head></html>"
      system "#{bin}/tauri", "init", "--ci", "--app-name", "test-app", "--window-title", "test-app", "--dist-dir",
  testpath/"dist", "--dev-path", testpath/"dist", "--before-dev-command", "", "--before-build-command", ""
  
      # test that tauri build works
      system "sed", "-i", "", "s/com.tauri.dev/com.tauri.test/", testpath/"src-tauri/tauri.conf.json"
      system "sed", "-i", "", "s/\"targets\": \"all\"/\"targets\": \"app\"/", testpath/"src-tauri/tauri.conf.json"
  
      system "#{bin}/tauri", "build", "--debug"
    end
  end
  