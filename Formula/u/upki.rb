class Upki < Formula
  desc "Implements platform-independent browser-grade certificate infrastructure"
  homepage "https://github.com/rustls/upki"
  url "https://github.com/rustls/upki/archive/refs/tags/v1.0.4.tar.gz"
  sha256 "4ec99d1e5281c6db788ec5f6929ba951d19bf84e87bad8494be75173d5332d9b"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/rustls/upki.git", branch: "main"

  bottle do
    manifest_sha256 "d6c870c95222ff5e3b35016edaa83bf6198a415a603e6b4603bb6789f1a92e8b"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1ee4ecb27794837674e8e1e51c32d7ca06934f8a45e340ef8bdc254435992476"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e8cc276639835796e71754470d9f04562111163380ca6c295d12873d4fd79bd7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e6d0a0c72fde01f8c68fd9a045d4cca2fa2cb18cf4983c03ee3ff803386b4ef5"
    sha256 cellar: :any,                 arm64_linux:       "10a3163f49e6d134782304f539169eed86928454c608d8da6b45c75405880341"
    sha256 cellar: :any,                 x86_64_linux:      "3c21747d4fa43c4fdd79ac124885b2048e198f42d07fddeceba918270a1da8da"
  end

  depends_on "rust" => :build

  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "upki-cli")
  end

  service do
    run [opt_bin/"upki", "fetch"]
    run_type :interval
    interval 7200
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/upki --version")

    system bin/"upki", "fetch"
    system bin/"upki", "verify"

    revoked_chain = <<~PEM
      -----BEGIN CERTIFICATE-----
      MIIF9jCCBZugAwIBAgIRANHEfplhI5PJ71fbEn77ss8wCgYIKoZIzj0EAwIwgZIx
      CzAJBgNVBAYTAkdCMRswGQYDVQQIExJHcmVhdGVyIE1hbmNoZXN0ZXIxEDAOBgNV
      BAcTB1NhbGZvcmQxGjAYBgNVBAoTEUNPTU9ETyBDQSBMaW1pdGVkMTgwNgYDVQQD
      Ey9DT01PRE8gRUNDIEV4dGVuZGVkIFZhbGlkYXRpb24gU2VjdXJlIFNlcnZlciBD
      QTAeFw0yNjA5MTUwMDAwMDBaFw0yNzA0MDEyMzU5NTlaMIG5MREwDwYDVQQFEwgw
      NDA1ODY5MDETMBEGCysGAQQBgjc8AgEDEwJHQjEdMBsGA1UEDxMUUHJpdmF0ZSBP
      cmdhbml6YXRpb24xCzAJBgNVBAYTAkdCMQ8wDQYDVQQIEwZMb25kb24xGDAWBgNV
      BAoTD1NlY3RpZ28gTGltaXRlZDE4MDYGA1UEAxMvY29tb2RvZWNjY2VydGlmaWNh
      dGlvbmF1dGhvcml0eS1ldi5jb21vZG9jYS5jb20wWTATBgcqhkjOPQIBBggqhkjO
      PQMBBwNCAAQsEmVYkMgFPehYn1F28BvMYM/vaZGFFmKL3DWgoNp04qFKRcGJv7YE
      /Ci08FmLpaNY07E41hgF3K9T0tiIjSj4o4IDpzCCA6MwHwYDVR0jBBgwFoAU007D
      GbpYWdEcYLdhU0c7p3eP+IowHQYDVR0OBBYEFGx9PPlVV9PRIuRhPR/wKdf7kDan
      MA4GA1UdDwEB/wQEAwIHgDAMBgNVHRMBAf8EAjAAMBMGA1UdJQQMMAoGCCsGAQUF
      BwMBMEkGA1UdIARCMEAwNQYMKwYBBAGyMQECAQUBMCUwIwYIKwYBBQUHAgEWF2h0
      dHBzOi8vc2VjdGlnby5jb20vQ1BTMAcGBWeBDAEBMFYGA1UdHwRPME0wS6BJoEeG
      RWh0dHA6Ly9jcmwuY29tb2RvY2EuY29tL0NPTU9ET0VDQ0V4dGVuZGVkVmFsaWRh
      dGlvblNlY3VyZVNlcnZlckNBLmNybDCBhwYIKwYBBQUHAQEEezB5MFEGCCsGAQUF
      BzAChkVodHRwOi8vY3J0LmNvbW9kb2NhLmNvbS9DT01PRE9FQ0NFeHRlbmRlZFZh
      bGlkYXRpb25TZWN1cmVTZXJ2ZXJDQS5jcnQwJAYIKwYBBQUHMAGGGGh0dHA6Ly9v
      Y3NwLmNvbW9kb2NhLmNvbTBvBgNVHREEaDBmgi9jb21vZG9lY2NjZXJ0aWZpY2F0
      aW9uYXV0aG9yaXR5LWV2LmNvbW9kb2NhLmNvbYIzd3d3LmNvbW9kb2VjY2NlcnRp
      ZmljYXRpb25hdXRob3JpdHktZXYuY29tb2RvY2EuY29tMIIBjgYKKwYBBAHWeQIE
      AgSCAX4EggF6AXgAdgBEwr0M6RQOZKXJSgGTClqhuzWXDgDuERaJaCocRNe1ZgAA
      AaCljXoTAAAEAwBHMEUCIQD+tsCdrVQg1FWwKrui/y49aAl3rRNd23itC1ENwjqQ
      aAIgN6eP/mjtl/OX/r/0aL+YBta3KXqGL4PtPX6K9CStIYwAfwAai51rjdeR0c0F
      Se22A1XWBrZPrTDbcf54jw/HyPvEsQAAAaCljXrwAAgAAAUABDC6dwQDAEgwRgIh
      AMGzX+ACFvOFcHIShgL0wBSYsuQSWHevLFCvqrDjsAe1AiEAizPjSCzPInqk9Ccn
      8XRQnjYEgPH6WQrLfjzpAjyYnj0AfQBZbmwzhpSyWXKiVsig6N2QSnboCD3ahzsB
      CDgoFDzuWQAAAaCljXsEAAgAAAUABIb13QQDAEYwRAIgHbUiL0BI+0gX7KxDf3lT
      8tI6UzuheUZufw5jzLncCfcCIGmTlAHw1TCN6toBpk2YXddwMqqP7miHUpf7FIKT
      IduLMAoGCCqGSM49BAMCA0kAMEYCIQDLFTwcbRGEuqhZp6xJv6zvSh1CYEM3ac03
      7EUA6PPqPwIhAMWPB/bv1VvWZaWlxKb1N1RPP15N3SPY8T9akJoN8l+s
      -----END CERTIFICATE-----
      -----BEGIN CERTIFICATE-----
      MIIDojCCAyigAwIBAgIQBh1GQ7QStdjXFUmdhVOqAzAKBggqhkjOPQQDAzCBhTEL
      MAkGA1UEBhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UE
      BxMHU2FsZm9yZDEaMBgGA1UEChMRQ09NT0RPIENBIExpbWl0ZWQxKzApBgNVBAMT
      IkNPTU9ETyBFQ0MgQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkwHhcNMTMwNDE1MDAw
      MDAwWhcNMjgwNDE0MjM1OTU5WjCBkjELMAkGA1UEBhMCR0IxGzAZBgNVBAgTEkdy
      ZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEaMBgGA1UEChMRQ09N
      T0RPIENBIExpbWl0ZWQxODA2BgNVBAMTL0NPTU9ETyBFQ0MgRXh0ZW5kZWQgVmFs
      aWRhdGlvbiBTZWN1cmUgU2VydmVyIENBMFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcD
      QgAEV3AaPyeTQy0aWXXkBJMR42DsJ5pnbliJe7ndaHzCDslVlY8ofpxeFiqluZrK
      KNcJeBU/Jl1YI9jLMyMZKsfSoaOCAWkwggFlMB8GA1UdIwQYMBaAFHVxpxlIGbyd
      nepBR9+UxEh3mdN5MB0GA1UdDgQWBBTTTsMZulhZ0Rxgt2FTRzund4/4ijAOBgNV
      HQ8BAf8EBAMCAYYwEgYDVR0TAQH/BAgwBgEB/wIBADA+BgNVHSAENzA1MDMGBFUd
      IAAwKzApBggrBgEFBQcCARYdaHR0cHM6Ly9zZWN1cmUuY29tb2RvLmNvbS9DUFMw
      TAYDVR0fBEUwQzBBoD+gPYY7aHR0cDovL2NybC5jb21vZG9jYS5jb20vQ09NT0RP
      RUNDQ2VydGlmaWNhdGlvbkF1dGhvcml0eS5jcmwwcQYIKwYBBQUHAQEEZTBjMDsG
      CCsGAQUFBzAChi9odHRwOi8vY3J0LmNvbW9kb2NhLmNvbS9DT01PRE9FQ0NBZGRU
      cnVzdENBLmNydDAkBggrBgEFBQcwAYYYaHR0cDovL29jc3AuY29tb2RvY2EuY29t
      MAoGCCqGSM49BAMDA2gAMGUCMQDmPWS98nREWdt4xB83r9MVvgG5INpKHi6V1dUY
      lCqvSvXXjK0QvZSrOB7cj9RavGgCMG2xJNG+SvlTWEYpmK7eXSgmRUgoBDeQ0yDK
      lnxmeeOBnnCaDIxAcA3aCj2Gtdt3sA==
      -----END CERTIFICATE-----
    PEM
    assert_equal "CertainlyRevoked\n",
                 pipe_output("#{bin}/upki revocation check", revoked_chain, 2)
  end
end
