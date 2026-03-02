class Summarize < Formula
  desc "Multi-modal AI tool to extract and summarize content"
  homepage "https://summarize.sh"
  url "https://github.com/steipete/summarize/archive/refs/tags/v0.11.1.tar.gz"
  sha256 "dacdd7032f5ebc745942d8535918488e4bfb678d0ae4f8941471081a8e97c41b"
  license "MIT"

  depends_on "pnpm" => :build
  depends_on "ffmpeg"
  depends_on "node"
  depends_on "tesseract"
  depends_on "yt-dlp"

  def install
    (buildpath/"pnpm-workspace.yaml").append_lines <<~YAML
      managePackageManagerVersions: false
    YAML

    system "git", "init"
    system "git", "config", "user.email", "you@example.com"
    system "git", "config", "user.name", "Your Name"
    system "git", "add", "."
    system "git", "commit", "-m", "init"

    system "pnpm", "install", "--frozen-lockfile", "--config.node-linker=hoisted"
    system "pnpm", "install", "--prod", "--frozen-lockfile", "--ignore-scripts", "--config.node-linker=hoisted"

    Dir.glob(
      "node_modules/**/{*node-notifier/vendor,*fsevents*/*.node,*oxfmt*/**,*oxlint*/**,*esbuild*/**,*rollup*/**}",
      File::FNM_DOTMATCH,
    ).each { |path| rm_r path if File.exist?(path) }
    Dir.glob("node_modules/**/*", File::FNM_DOTMATCH).each do |path|
      File.delete(path) if File.symlink?(path) && !File.exist?(path)
    end

    chmod 0755, "dist/cli.js"
    libexec.install Dir["*"]
    bin.install_symlink libexec/"dist/cli.js" => "summarize"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/summarize --version")
    assert_match "Cache path:", shell_output("#{bin}/summarize --cache-stats")
  end
end
