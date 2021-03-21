class Xeora < Formula
  desc "Web Development Framework"
  homepage "https://xeora.org"
  url "https://github.com/xeora/v7-framework/archive/v7.4.7750.tar.gz"
  sha256 "67227cad56a6dc407fb15da5991f71e508190de8feb1811b5319d28fcb68004b"
  license "MIT"
  head "https://github.com/xeora/v7-framework.git"

  depends_on "dotnet"

  def install
    system "dotnet", "build",
           "--configuration", "Release",
           "--framework", "netcoreapp#{Formula["dotnet"].version.major_minor}",
           "--output", "out",
           "src/Xeora.CLI/Xeora.CLI.csproj"

    libexec.install Dir["out/*"]

    (bin/"xeora").write <<~EOS
      #!/bin/sh
      exec "#{Formula["dotnet"].opt_bin}/dotnet" "#{libexec}/xeora.dll" "$@"
    EOS
  end

  test do
    system "xeora", "create", "-x", testpath
    system "xeora", "compile", "-y", "-d", "Main", testpath
    assert_match("e7fb8a97a6f8e81a24ca9f6d832d4c22",
      shell_output("/sbin/md5 -q #{testpath}/Domains/Main/Content.xeora"))
  end
end
