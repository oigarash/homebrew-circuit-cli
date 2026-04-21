class CircuitCli < Formula
  desc "CLI tool for Cisco Circuit (circuit.cisco.com)"
  homepage "https://gitlab-cxj.cisco.com/jtac-apps/circuit-cli"
  url "https://gitlab-cxj.cisco.com/jtac-apps/circuit-cli/-/archive/v0.5.1/circuit-cli-v0.5.1.tar.gz"
  sha256 "241ed9f7e4179e4f09021485558d6626456e3c0a1dfdb472b705b277e57111d3"
  license "MIT"

  depends_on "python@3.11"

  def install
    venv = libexec/"venv"
    system "python3.11", "-m", "venv", venv.to_s
    # Temporary bin stub so Homebrew sees something in bin/ during install.
    (bin/"circuit").write <<~SH
      #!/bin/bash
      echo "Run 'brew postinstall circuit-cli' to complete installation" >&2
      exit 1
    SH
    (bin/"circuit").chmod 0755
  end

  def post_install
    venv = libexec/"venv"
    # Install circuit-cli + all deps from the GitLab archive URL (binary wheels).
    system venv/"bin/pip", "install",
           "circuit-cli @ #{stable.url}",
           "playwright>=1.44.0",
           "pyobjc-framework-Quartz>=10.0"

    # Replace stub with real entry point.
    (bin/"circuit").delete if (bin/"circuit").exist?
    (bin/"circuit").write <<~SH
      #!/bin/bash
      exec "#{venv}/bin/circuit" "$@"
    SH
    (bin/"circuit").chmod 0755

    opoo <<~EOS
      Playwright browser is required for authentication.
      Run the following command after installation:

        #{venv}/bin/python -m playwright install chromium
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/circuit --version")
  end
end
