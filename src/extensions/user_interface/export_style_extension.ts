import { WebviewExtension } from '../webview_extension';

export class ExportStyleExtension implements WebviewExtension {
  public generateContent(): string {
    return `
      #export-glsl {
        position: absolute;
        bottom: 0;
        left: 50%;
        transform: translateX(-50%);
        color: #fff;
        padding: 3px 5px;
        background: #000;
        border-radius: 5px;
        z-index: 1;
      }
    `;
  }
}
