class TechnitiumLibrary < Formula
  desc "Library for technitium .net based applications"
  homepage "https://technitium.com"
  url "https://github.com/TechnitiumSoftware/TechnitiumLibrary/archive/refs/tags/dns-server-v15.6.2.tar.gz"
  sha256 "e7f5add92da555fc3120991fabd802c0605ab9c45cb4b56137dfb0699a006cec"
  license "GPL-3.0-only"
  revision 1
  compatibility_version 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8a1edec6890fdc1ee779c1d160ba19802f2cdbf558d1f3c6610c41332d3941a9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a8951d861eabae1b1063070370b86e833df6aa901f47b042b3068906bbaca01e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2851a1c1c8660c02f408fed599ab659bf813cd59506357d509a5b201f8ff3bbf"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b2b88a0c4bbc8b1d72fc1dbd87c74719b883dc32fb23aaed00a04f1e08dd77ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "592c64756ab807a028bf409c09763cf7f40bf4929427778303b6a50e56ce1248"
  end

  depends_on "dotnet@10"

  deny_network_access!

  def dotnet = deps.find { |d| d.name.match? Version.formula_optionally_versioned_regex(:dotnet) }.to_formula

  def libraries
    %w[
      TechnitiumLibrary.ByteTree/TechnitiumLibrary.ByteTree.csproj
      TechnitiumLibrary.Net/TechnitiumLibrary.Net.csproj
      TechnitiumLibrary.Security.OTP/TechnitiumLibrary.Security.OTP.csproj
    ]
  end

  def fetch
    ENV["XDG_RUNTIME_DIR"] = buildpath
    args = [
      "--use-current-runtime",
      "-p:TargetFrameworks=net#{dotnet.version.major_minor}",
    ]
    libraries.each { |library| system "dotnet", "restore", library, *args }
  end

  def install
    ENV["DOTNET_CLI_TELEMETRY_OPTOUT"] = "1"
    ENV["XDG_RUNTIME_DIR"] = buildpath

    args = %W[
      --configuration Release
      --framework net#{dotnet.version.major_minor}
      --no-self-contained
      --output #{libexec}
      --use-current-runtime
    ]

    libraries.each { |library| system "dotnet", "publish", library, *args }
  end

  test do
    # .NET named mutexes need `XDG_RUNTIME_DIR` (or `USER`) on Linux, which test containers may lack
    ENV["XDG_RUNTIME_DIR"] = testpath
    target_framework = "net#{dotnet.version.major_minor}"

    (testpath/"test.cs").write <<~CSHARP
      using System;
      using TechnitiumLibrary;

      namespace Homebrew
      {
        public class TechnitiumLibraryTest
        {
          public static void Main(string[] args)
          {
            Console.WriteLine(Base32.ToBase32HexString(new byte[] { 1, 2, 3 }));
          }
        }
      }
    CSHARP

    (testpath/"test.csproj").write <<~XML
      <Project Sdk="Microsoft.NET.Sdk">
        <PropertyGroup>
          <OutputType>Exe</OutputType>
          <TargetFrameworks>#{target_framework}</TargetFrameworks>
          <PlatformTarget>AnyCPU</PlatformTarget>
          <RootNamespace>Homebrew</RootNamespace>
          <PackageId>Homebrew.Dotnet</PackageId>
          <Title>Homebrew.Dotnet</Title>
          <Product>$(AssemblyName)</Product>
          <EnableDefaultCompileItems>false</EnableDefaultCompileItems>
        </PropertyGroup>
        <ItemGroup>
          <Compile Include="test.cs" />
        </ItemGroup>
        <ItemGroup>
          <Reference Include="TechnitiumLibrary">
            <HintPath>#{libexec}/TechnitiumLibrary.dll</HintPath>
          </Reference>
        </ItemGroup>
      </Project>
    XML

    system "#{dotnet.opt_libexec}/dotnet", "build", "--framework", target_framework,
           "--output", testpath, testpath/"test.csproj"
    output = shell_output("#{dotnet.opt_libexec}/dotnet run --framework #{target_framework} #{testpath}/test.dll")
    assert_match "04106===", output
  end
end
