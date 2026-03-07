class Zadark < Formula
  desc "Utilities for Zalo"
  homepage "https://zadark.com"
  url "https://github.com/quaric/zadark/archive/refs/tags/26.1.1.tar.gz"
  sha256 "05943f75517c534a95be4ee7cad2f07c9d1b48fd865724cab8b152bc1014fa32"
  license "MPL-2.0"

  depends_on "yarn" => :build
  depends_on :macos
  depends_on "node"

  def install
    inreplace "src/pc/index.js", "const prompt = require('prompt-sync')()",
                                 "#!/usr/bin/env node\n\nconst prompt = require('prompt-sync')()"
    system "npm", "pkg", "set", "bin.zadark=build/pc/index.js"

    system "yarn", "install", "--frozen-lockfile", "--ignore-scripts"
    system "yarn", "build"

    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zadark -v")

    (testpath/"Contents/Resources").mkpath
    (testpath/"Contents/Resources/app.asar.bak").write "dummy asar bak"
    (testpath/"Contents/Resources/app.asar").write "dummy asar"

    system bin/"zadark", "uninstall", testpath
    assert_path_exists testpath/"Contents/Resources/app.asar"
    refute_path_exists testpath/"Contents/Resources/app.asar.bak"
    assert_equal "dummy asar bak", (testpath/"Contents/Resources/app.asar").read
  end
end
