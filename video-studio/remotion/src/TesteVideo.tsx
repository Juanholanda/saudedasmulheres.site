import React from 'react';
import {AbsoluteFill, interpolate, spring, useCurrentFrame, useVideoConfig} from 'remotion';

export const TesteVideo: React.FC<{titulo: string}> = ({titulo}) => {
  const frame = useCurrentFrame();
  const {fps} = useVideoConfig();
  const escala = spring({frame, fps, config: {damping: 12}});
  const opacidade = interpolate(frame, [0, 20], [0, 1], {extrapolateRight: 'clamp'});
  return (
    <AbsoluteFill
      style={{
        background: 'linear-gradient(160deg, #be185d, #7c3aed)',
        justifyContent: 'center',
        alignItems: 'center',
        fontFamily: 'sans-serif',
      }}
    >
      <h1 style={{color: 'white', fontSize: 120, textAlign: 'center', transform: `scale(${escala})`, opacity: opacidade, padding: 60}}>
        {titulo}
      </h1>
      <p style={{color: '#fce7f3', fontSize: 56, opacity: opacidade}}>Remotion funcionando ✓</p>
    </AbsoluteFill>
  );
};
