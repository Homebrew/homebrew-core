require "language/node"

class YoCode < Formula
  desc "Visual Studio Code extension generator"
  homepage "https://www.npmjs.com/package/generator-code"
  url "https://registry.npmjs.org/generator-code/-/generator-code-1.5.5.tgz"
  sha256 "20f88617283018250f2f09eb7c2f9206d28c1d30e13695b9b6b642a03b95ca3a"
  license "MIT"

  depends_on "node"

  on_macos do
    depends_on "macos-term-size"
  end

  resource "yo" do
    url "https://registry.npmjs.org/yo/-/yo-4.3.0.tgz"
    sha256 "02bdc1bd1cf75fd1157f161b42e1c0bc374ca14ae71059533d99038c40d6941f"
  end

  def install
    resource("yo").stage do
      system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    end

    system "npm", "install", *Language::Node.std_npm_install_args(libexec)

    (bin/"yo-code").write <<~EOS
      #!/bin/bash
      exec #{libexec}/bin/yo code "$@"
    EOS

    term_size_vendor_dir = libexec/"lib/node_modules/yo/node_modules/term-size/vendor"
    term_size_vendor_dir.rmtree # remove pre-built binaries

    on_macos do
      macos_dir = term_size_vendor_dir/"macos"
      macos_dir.mkpath
      # Replace the vendored pre-built term-size with one we build ourselves
      ln_sf (Formula["macos-term-size"].opt_bin/"term-size").relative_path_from(macos_dir), macos_dir
    end
  end

  test do
    system "yo-code", "--extensionType=ts", "--extensionDisplayName=Test Extension", "--extensionId=test",
                      "--extensionDescription=Test description", "--gitInit", "--no-webpack", "--pkgManager=npm"

    assert_predicate testpath/"test/.git", :exist?
    assert_predicate testpath/"test/package.json", :exist?

    refute_predicate testpath/"test/webpack.config.js", :exist?
  end
end
